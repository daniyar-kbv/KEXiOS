//
//  PaymentMethodViewController.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import RxCocoa
import RxSwift
import UIKit

final class PaymentMethodViewController: UIViewController {
    private let viewModel: PaymentMethodVCViewModel
    private lazy var contentView = PaymentMethodView()

    let outputs = Output()

    init(viewModel: PaymentMethodVCViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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

//        Tech debt: localize
        title = "Способ оплаты"
        setBackButton { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        contentView.setTableViewDelegate(self)
    }
}

extension PaymentMethodViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.getCountOfPaymentMethods()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cell.textLabel?.textColor = .darkGray
        cell.textLabel?.text = viewModel.getPaymentMethod(for: indexPath).paymentType.title
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.getPaymentMethod(for: indexPath).paymentType {
        case .inApp:
            outputs.didSelectNewCard.accept(())
        default:
            break
        }
    }
}

extension PaymentMethodViewController {
    struct Output {
        let didSelectNewCard = PublishRelay<Void>()
    }
}
