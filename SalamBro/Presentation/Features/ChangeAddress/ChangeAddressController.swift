//
//  ChangeAddressController.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 19.05.2021.
//

import RxCocoa
import RxSwift
import UIKit

final class ChangeAddressController: ViewController {
    private let disposeBag: DisposeBag = .init()
    private let viewModel: ChangeAddressViewModel
    private let tableView = UITableView()
    private let saveButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Сохранить", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .calmGray
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        return btn
    }()

    init(viewModel: ChangeAddressViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = L10n.AddressPicker.titleMany
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 18, weight: .medium),
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "chevron.left"), style: .plain, target: self, action: #selector(goBack))
        viewModel.checkInputs()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        layoutUI()
        bind()
    }

    private func bind() {
        viewModel.outputs.reloadCellAt
            .bind { [weak self] indexPath in
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                self?.tableView.reloadData()
            }
            .disposed(by: disposeBag)

        viewModel.outputs.didEnterValidInputs
            .subscribe(onNext: { [weak self] isEnabled in
                self?.saveButton.isEnabled = isEnabled
                if isEnabled {
                    self?.saveButton.backgroundColor = .kexRed
                    return
                }
                self?.saveButton.backgroundColor = .calmGray

            })
            .disposed(by: disposeBag)

        saveButton.rx.tap
            .bind { [weak self] in
                self?.showConfirmationAlert()
            }
            .disposed(by: disposeBag)
    }

    private func showConfirmationAlert() {
        let alert = UIAlertController(title: "Вы уверены?", message: "Если Вы сейчас смените адрес, то потеряете все выбранные Вами продукты. Вы действительно хотите сменить адрес?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Нет", style: .default) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            self?.viewModel.changeAddress {
                self?.dismiss(animated: true)
            }
        }

        [cancelAction, yesAction].forEach { alert.addAction($0) }

        present(alert, animated: true, completion: nil)
    }

    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Configure UI & layout

extension ChangeAddressController {
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 64
        tableView.separatorColor = .white
        tableView.register(ChangeAddressBrandCell.self, forCellReuseIdentifier: ChangeAddressBrandCell.reuseIdentifier)
        tableView.register(ChangeAddressEmptyCell.self, forCellReuseIdentifier: ChangeAddressEmptyCell.reuseIdentifier)
        tableView.register(ChangeAddressTableViewCell.self, forCellReuseIdentifier: ChangeAddressTableViewCell.reuseIdentifier)
    }

    private func layoutUI() {
        view.backgroundColor = .white
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(42)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(saveButton.snp.top)
        }
    }
}

extension ChangeAddressController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.getCellsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = viewModel.getCellModel(for: indexPath)
        return viewModel.getCell(with: cellModel, for: indexPath, in: tableView)
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.changeRoute(indexPath: indexPath)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection _: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width - 40, height: 40))
        let lbl = UILabel(frame: CGRect(x: 25, y: 0, width: footerView.frame.size.width, height: 35))
        lbl.textColor = .mildBlue
        lbl.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        lbl.backgroundColor = .white
        lbl.text = "Наличие или отсутствие того или иного бренда - зависит от Вашего адреса доставки"
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        footerView.addSubview(lbl)
        return footerView
    }
}
