//
//  AddressPickController.swift
//  SalamBro
//
//  Created by Arystan on 5/4/21.
//

import Reusable
import RxCocoa
import RxSwift
import UIKit

// MARK: Tech debt, нужно переписать.

final class AddressPickController: ViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: AddressPickerViewModelProtocol
    private let tapGesture = UITapGestureRecognizer()
    
    let outputs = Output()

    private lazy var addLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        label.text = L10n.AddressPicker.add
        label.isUserInteractionEnabled = true
        return label
    }()

    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "add"), for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
        return button
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.tableFooterView = .init()
        view.separatorColor = .mildBlue
        view.delegate = self
        view.dataSource = self
        view.register(cellType: AddressPickerCell.self)
        view.addTableHeaderViewLine()
        view.separatorInset = .init(top: 0, left: 24, bottom: 0, right: 24)
        return view
    }()

    init(viewModel: AddressPickerViewModelProtocol) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        outputs.didTerminate.accept(())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind()
        bindViewModel()
    }

    private func bind() {
        plusButton.rx.tap
            .bind { [weak self] in
                self?.addTapped()
            }
            .disposed(by: disposeBag)

        tapGesture.rx.event
            .bind(onNext: { [weak self] _ in
                self?.addTapped()
            }).disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        viewModel.outputs.didSelectAddress.subscribe(onNext: { [weak self] address in
            self?.outputs.didSelectAddress.accept((
                address,
                { [weak self] in
                    self?.viewModel.reload()
                }
            ))
        }).disposed(by: disposeBag)
        
        viewModel.outputs.onReload.subscribe(onNext: { [weak self] in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    func addTapped() {
        outputs.didAddTapped.accept({ [weak self] in
            self?.viewModel.reload()
        })
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = L10n.AddressPicker.titleMany
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .white
        addLabel.addGestureRecognizer(tapGesture)
        [addLabel, plusButton, tableView].forEach { view.addSubview($0) }
    }

    private func setupConstraints() {
        addLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.left.equalToSuperview().offset(24)
            $0.width.equalTo(360)
        }

        plusButton.snp.makeConstraints {
            $0.centerY.equalTo(addLabel)
            $0.trailing.equalToSuperview().offset(-16)
            $0.size.equalTo(24)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(addLabel.snp.bottom).offset(16)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

extension AddressPickController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelect(index: indexPath.row)
    }

    public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.cellViewModels.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: AddressPickerCell.self)
        cell.set(viewModel: viewModel.cellViewModels[indexPath.row])
        return cell
    }
}

extension AddressPickController {
    struct Output {
        let didSelectAddress = PublishRelay<(Address, () -> Void)>()
        let didAddTapped = PublishRelay<() -> Void>()
        let didTerminate = PublishRelay<Void>()
    }
}
