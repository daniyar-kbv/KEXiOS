//
//  PaymentEditController.swift
//  SalamBro
//
//  Created by Dan on 7/29/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

final class PaymentEditController: UIViewController, AlertDisplayable, LoaderDisplayable {
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(PaymentEditCell.self, forCellReuseIdentifier: String(describing: PaymentEditCell.self))
        view.rowHeight = 48
        view.backgroundColor = .arcticWhite
        view.tableFooterView = UIView()
        view.separatorColor = .mildBlue
        view.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        view.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 16)
        view.delegate = self
        view.dataSource = self
        return view
    }()

    private lazy var deleteButton: UIButton = {
        let view = UIButton()
        view.tintColor = .kexRed
        view.setImage(SBImageResource.getIcon(for: PaymentIcons.PaymentEdit.delete), for: .normal)
        view.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        return view
    }()

    private let disposeBag = DisposeBag()
    private let viewModel: PaymentEditViewModel

    let outputs = Output()

    init(viewModel: PaymentEditViewModel) {
        self.viewModel = viewModel

        super.init(nibName: .none, bundle: .none)

        bindViewModel()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = SBLocalization.localized(key: PaymentText.PaymentEdit.title)
        setBackButton { [weak self] in
            self?.outputs.close.accept(())
        }

        viewModel.getCards()
    }
}

extension PaymentEditController {
    private func bindViewModel() {
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

        viewModel.outputs.needsClose
            .bind(to: outputs.close)
            .disposed(by: disposeBag)

        viewModel.outputs.needsUpdate
            .bind(to: tableView.rx.reload)
            .disposed(by: disposeBag)

        viewModel.outputs.canDelete
            .subscribe(onNext: { [weak self] canDelete in
                guard let deleteButton = self?.deleteButton else { return }
                self?.navigationItem.rightBarButtonItem = canDelete ?
                    .init(customView: deleteButton) :
                    .init()
            })
            .disposed(by: disposeBag)
    }

    @objc private func deleteAction() {
        showAlert(
            title: SBLocalization.localized(key: PaymentText.PaymentEdit.Alert.title),
            message: SBLocalization.localized(key: PaymentText.PaymentEdit.Alert.message),
            actions: [
                .init(title: SBLocalization.localized(key: PaymentText.PaymentEdit.Alert.yes),
                      style: .default,
                      handler: { [weak self] _ in
                          self?.viewModel.deleteCards()
                      }),
                .init(title: SBLocalization.localized(key: PaymentText.PaymentEdit.Alert.no),
                      style: .default,
                      handler: nil),
            ]
        )
    }
}

extension PaymentEditController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PaymentEditCell.self), for: indexPath) as! PaymentEditCell
        let info = viewModel.cellInfo(for: indexPath.row)
        cell.configure(cardTitle: info.cardTitle, isSelected: info.isSelected)
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectCard(at: indexPath.row)
    }
}

extension PaymentEditController {
    struct Output {
        let close = PublishRelay<Void>()
    }
}
