//
//  AddressDetailController.swift
//  SalamBro
//
//  Created by Arystan on 5/7/21.
//

import RxCocoa
import RxSwift
import UIKit

final class AddressDetailController: UIViewController, LoaderDisplayable, AlertDisplayable {
    let outputs = Output()

    private let viewModel: AddressDetailViewModel
    private let disposeBag = DisposeBag()

    private lazy var deleteButton: UIButton = {
        let view = UIButton()
        view.tintColor = .kexRed
        view.setImage(SBImageResource.getIcon(for: ProfileIcons.AddressList.addressRemoveIcon), for: .normal)
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
        viewModel.outputs.didStartRequest
            .subscribe(onNext: { [weak self] in
                self?.showLoader()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.didEndRequest
            .subscribe(onNext: { [weak self] in
                self?.hideLoader()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.didGetError
            .subscribe(onNext: { [weak self] error in
                self?.showError(error)
            })
            .disposed(by: disposeBag)

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
        navigationItem.title = SBLocalization.localized(key: ProfileText.AddressDetail.title)
    }
}

extension AddressDetailController {
    @objc private func dismissVC() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func deleteAction() {
        let alert = UIAlertController(title: SBLocalization.localized(key: ProfileText.AddressDetail.Alert.title),
                                      message: SBLocalization.localized(
                                          key: ProfileText.AddressDetail.Alert.message
                                      ),
                                      preferredStyle: .alert)
        alert.view.tintColor = .kexRed
        alert.addAction(UIAlertAction(title: SBLocalization.localized(
                key: ProfileText.AddressDetail.Alert.Action.yes
            ),
            style: .default,
            handler: { [weak self] _ in
                self?.viewModel.delete()
            }))
        alert.addAction(UIAlertAction(title: SBLocalization.localized(
                key: ProfileText.AddressDetail.Alert.Action.no
            ),
            style: .default))
        present(alert, animated: true, completion: nil)
    }
}

extension AddressDetailController {
    struct Output {
        let didDeleteAddress = PublishRelay<Void>()
    }
}
