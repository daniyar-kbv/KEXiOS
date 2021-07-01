//
//  AddressDetailController.swift
//  SalamBro
//
//  Created by Arystan on 5/7/21.
//

import RxCocoa
import RxSwift
import UIKit

final class AddressDetailController: UIViewController {
    let outputs = Output()

    private let viewModel: AddressDetailViewModel
    private let disposeBag = DisposeBag()

    private lazy var deleteButton: UIButton = {
        let view = UIButton()
        view.tintColor = .kexRed
        view.setImage(SBImageResource.getIcon(for: AddressListIcon.addressRemoveIcon), for: .normal)
        view.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        return view
    }()

    private var contentView = AddressDetailView()

    init(viewModel: AddressDetailViewModel) {
        self.viewModel = viewModel

        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    func bindViewModel() {
        viewModel.outputs.addressName
            .subscribe(onNext: { [weak self] addressName in
                guard let addressName = addressName else { return }
                self?.contentView.configureAddress(name: addressName)
            }).disposed(by: disposeBag)

        viewModel.outputs.comment
            .subscribe(onNext: { [weak self] comment in
                guard let comment = comment else { return }
                self?.contentView.configureCommentary(commentary: comment)
            }).disposed(by: disposeBag)

        viewModel.outputs.isCurrent
            .subscribe(onNext: { [weak self] isCurrent in
                guard !isCurrent,
                      let deleteButton = self?.deleteButton else { return }
                self?.navigationItem.rightBarButtonItem = .init(customView: deleteButton)
            }).disposed(by: disposeBag)

        viewModel.outputs.didDelete
            .bind(to: outputs.didDeleteAddress)
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = L10n.AddressPicker.titleOne
    }
}

extension AddressDetailController {
    @objc private func dismissVC() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func deleteAction() {
//        Tech debt add localization
        let alert = UIAlertController(title: "Вы уверены?", message: "Вы уверены что хотите удалить адрес доставки?", preferredStyle: .alert)
        alert.view.tintColor = .kexRed
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] _ in
            self?.viewModel.delete()
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default))
        present(alert, animated: true, completion: nil)
    }
}

extension AddressDetailController {
    struct Output {
        let didDeleteAddress = PublishRelay<Void>()
    }
}
