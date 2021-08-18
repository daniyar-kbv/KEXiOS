//
//  OrderHistoryCellTopView.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/23/21.
//

import SnapKit
import UIKit

protocol OrderHistoryViewDelegate: AnyObject {
    func shareToInstagramTapped()
    func rateOrder(at orderNumber: Int)
}

final class OrderHistoryCellContentView: UIView {
    weak var delegate: OrderHistoryViewDelegate?

    private lazy var logoView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.adjustsFontSizeToFitWidth = true
        return view
    }()

    private lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.textColor = .mildBlue
        view.font = .systemFont(ofSize: 14)
        view.adjustsFontSizeToFitWidth = true
        return view
    }()

    private lazy var checkNumberLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 10)
        view.textColor = .mildBlue
        view.adjustsFontSizeToFitWidth = true
        return view
    }()

    private lazy var orderInfoStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            titleLabel,
            dateLabel,
            checkNumberLabel,
        ])
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.spacing = 1
        return view
    }()

    private lazy var shareToInstagramButton: UIButton = {
        let view = UIButton()
        view.setImage(SBImageResource.getIcon(for: ProfileIcons.OrdersHistory.shareToInstagram), for: .normal)
        return view
    }()

    private lazy var deliveryItem = OrderHistoryItemStackView()
    private lazy var sumItem = OrderHistoryItemStackView()

    private lazy var itemStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 8
        return view
    }()

    private lazy var addressItem = OrderHistoryInfoStackView(
        title: SBLocalization.localized(key: ProfileText.OrderHistory.deliveryAddress))
    private lazy var paymentItem = OrderHistoryInfoStackView(
        title: SBLocalization.localized(key: ProfileText.OrderHistory.paymentDetails))
    private lazy var statusItem = OrderHistoryInfoStackView(
        title: SBLocalization.localized(key: ProfileText.OrderHistory.orderStatus))

    private lazy var infoStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            addressItem,
            paymentItem,
            statusItem,
        ])
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.spacing = 8
        return view
    }()

    private lazy var sendCheckButton = OrderHistoryButton(
        color: .black,
        titleString: SBLocalization.localized(key: ProfileText.OrderHistory.sendBill)
    )
    private lazy var rateOrderButton = OrderHistoryButton(
        color: .kexRed,
        titleString: SBLocalization.localized(key: ProfileText.OrderHistory.rateOrder)
    )
    private lazy var repeatOrderButton = OrderHistoryButton(
        color: .mildBlue,
        titleString: SBLocalization.localized(key: ProfileText.OrderHistory.repeatOrder)
    )
    private lazy var cancelOrderButton = OrderHistoryButton(
        color: .mildBlue,
        titleString: SBLocalization.localized(key: ProfileText.OrderHistory.cancelOrder)
    )

    private lazy var buttonStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [sendCheckButton,
                                                  rateOrderButton, repeatOrderButton, cancelOrderButton])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 16
        return view
    }()

    private var orderedItems: [OrderHistoryItemStackView]?

    private var orderStatus: OrderedFoodStatus?

    private var orderNumber: Int?

    init(delegate: OrderHistoryViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        layoutUI()
        configureActions()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureActions() {
        shareToInstagramButton.addTarget(self, action: #selector(shareToInstagram), for: .touchUpInside)
        rateOrderButton.addTarget(self, action: #selector(rateOrder), for: .touchUpInside)
    }

    private func layoutUI() {
        [logoView, orderInfoStack, shareToInstagramButton].forEach {
            addSubview($0)
        }
        logoView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(24)
            $0.left.equalToSuperview()
            $0.height.width.equalTo(48)
        }
        orderInfoStack.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(24)
            $0.left.equalTo(logoView.snp.right).offset(16)
            $0.right.equalTo(shareToInstagramButton.snp.left).offset(-16)
            $0.height.equalTo(48)
        }
        shareToInstagramButton.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalTo(logoView.snp.centerY)
            $0.height.equalTo(36)
            $0.width.equalTo(107)
        }

        addSubview(itemStack)
        itemStack.snp.makeConstraints {
            $0.top.equalTo(orderInfoStack.snp.bottom).offset(16)
            $0.left.right.equalToSuperview()
        }

        addSubview(infoStack)
        infoStack.snp.makeConstraints {
            $0.top.equalTo(itemStack.snp.bottom).offset(16)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-24)
        }

        if orderStatus == .paid || orderStatus != .cooking || orderStatus != .inDelivery {
            switch orderStatus {
            case .new:
                sendCheckButton.isHidden = true
                repeatOrderButton.isHidden = true
                rateOrderButton.isHidden = true
            case .failure:
                sendCheckButton.isHidden = true
                cancelOrderButton.isHidden = true
                rateOrderButton.isHidden = true
            case .paid:
                cancelOrderButton.isHidden = true
            default:
                return
            }

            infoStack.snp.remakeConstraints {
                $0.top.equalTo(itemStack.snp.bottom).offset(16)
                $0.left.right.equalToSuperview()
            }

            addSubview(buttonStack)
            buttonStack.snp.makeConstraints {
                $0.top.equalTo(infoStack.snp.bottom).offset(16)
                $0.left.right.equalToSuperview()
                $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-24)
            }
        }
    }

    func configure(with item: OrdersList) {
        if let imageURL = URL(string: item.brand.image) {
            logoView.setImage(url: imageURL)
        }

        titleLabel.text = item.brand.name
        dateLabel.text = getConvertedDate(of: item.createdDate)
        checkNumberLabel.text = "№\(item.id)"

        if let deliveryPrice = Double("500.0"), let totalSum = Double(item.price) {
            configureItems(with: item.cart.items, deliveryPrice: deliveryPrice, totalSum: totalSum)
        }

        if let address = item.address.getName() {
            addressItem.configure(with: address)
        }

        if let paymentType = PaymentMethodType(rawValue: item.paymentType),
           let orderStatus = OrderedFoodStatus(rawValue: item.status)
        {
            paymentItem.configure(with: PaymentMethod(type: paymentType).title)
            statusItem.configure(with: orderStatus.title)
            self.orderStatus = orderStatus
        }

        orderNumber = item.id

        layoutUI()
    }

    private func configureItems(with items: [CartItem], deliveryPrice: Double, totalSum: Double) {
        guard itemStack.arrangedSubviews.isEmpty else { return }

        items.forEach { item in
            var title = "\(item.count)x \(item.position.name)"
            if !item.modifierGroups.isEmpty {
                let modifiersText = item.modifierGroups.map { $0.modifiers }.flatMap { $0 }.map { $0.position.name }.joined(separator: ", ")
                title += " (\(modifiersText))"
            }
            if let price = item.position.price {
                itemStack.addArrangedSubview(OrderHistoryItemStackView(
                    with: title,
                    and: "\(price.formattedWithSeparator) ₸"
                ))
            }
        }

        deliveryItem.configure(with: SBLocalization.localized(key: ProfileText.OrderHistory.shipping), and: "\(Int(deliveryPrice)) ₸")
        sumItem.configure(with: SBLocalization.localized(key: ProfileText.OrderHistory.sum), and: "\(Int(totalSum)) ₸")

        itemStack.addArrangedSubview(deliveryItem)
        itemStack.addArrangedSubview(sumItem)
    }

    private func getConvertedDate(of date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let convertedDate = dateFormatter.date(from: date)

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd.MM.yy, HH:mm"

        if let convertedDate = convertedDate {
            return dateFormatterPrint.string(from: convertedDate)
        } else {
            return ""
        }
    }

    @objc private func rateOrder() {
        guard let orderNumber = orderNumber else { return }
        delegate?.rateOrder(at: orderNumber)
    }

    @objc private func shareToInstagram() {
        delegate?.shareToInstagramTapped()
    }
}
