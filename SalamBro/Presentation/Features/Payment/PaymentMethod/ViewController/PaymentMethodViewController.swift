//
//  PaymentMethodViewController.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import RxCocoa
import RxSwift
import UIKit

final class PaymentMethodViewController: UIViewController, LoaderDisplayable {
    private let disposeBag = DisposeBag()
    private let viewModel: PaymentMethodVCViewModel
    private lazy var contentView = PaymentMethodView()

    private lazy var editButton: UIButton = {
        let view = UIButton()
        view.tintColor = .kexRed
        view.setImage(SBImageResource.getIcon(for: PaymentIcons.PaymentMethod.edit), for: .normal)
        view.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        return view
    }()

    let outputs = Output()

    init(viewModel: PaymentMethodVCViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        bindViewModel()
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

        title = SBLocalization.localized(key: PaymentText.PaymentMethod.title)
        setBackButton { [weak self] in
            self?.outputs.close.accept(())
        }

        contentView.setTableViewDelegate(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.getPaymentMethods()
    }
}

extension PaymentMethodViewController {
    private func bindViewModel() {
        viewModel.outputs.didStartRequest
            .subscribe(onNext: { [weak self] in
                self?.showLoader()
            }).disposed(by: disposeBag)

        viewModel.outputs.didEndRequest
            .subscribe(onNext: { [weak self] in
                self?.hideLoader()
            }).disposed(by: disposeBag)

        viewModel.outputs.didGetError
            .subscribe(onNext: { [weak self] error in
                self?.showError(error)
            }).disposed(by: disposeBag)

        viewModel.outputs.needsUpdate
            .bind(to: contentView.tableView.rx.reload)
            .disposed(by: disposeBag)

        viewModel.outputs.didSelectPaymentMethod
            .bind(to: outputs.didSelectPaymentMethod)
            .disposed(by: disposeBag)

        viewModel.outputs.showPaymentMethod
            .bind(to: outputs.showPaymentMethod)
            .disposed(by: disposeBag)

        viewModel.outputs.canEdit
            .subscribe(onNext: { [weak self] canEdit in
                guard let editButton = self?.editButton else { return }
                self?.navigationItem.rightBarButtonItem = canEdit ?
                    .init(customView: editButton) :
                    .init()
            })
            .disposed(by: disposeBag)
    }

    @objc private func editAction() {
        outputs.toEdit.accept(())
    }
}

extension PaymentMethodViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.getCountOfPaymentMethods()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PaymentMethodCell.self), for: indexPath) as! PaymentMethodCell
        let paymentMethodInfo = viewModel.getPaymentMethodInfo(for: indexPath)
        cell.configure(title: paymentMethodInfo.paymentMethodTitle,
                       isSelected: paymentMethodInfo.isSelected,
                       isApplePay: paymentMethodInfo.isApplePay)
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectPaymentMethod(at: indexPath)
    }
}

extension PaymentMethodViewController {
    struct Output {
        let close = PublishRelay<Void>()
        let didSelectPaymentMethod = PublishRelay<Void>()
        let showPaymentMethod = PublishRelay<PaymentMethod>()
        let toEdit = PublishRelay<Void>()
    }
}
