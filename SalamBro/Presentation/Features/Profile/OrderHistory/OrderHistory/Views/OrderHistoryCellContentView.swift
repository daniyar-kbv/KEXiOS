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
        view.font = .systemFont(ofSize: 10, weight: .medium)
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

    private lazy var deliveryItem = OrderHistoryItemView()
    private lazy var sumItem = OrderHistoryItemView()

    private lazy var itemStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 8
        return view
    }()

    private lazy var addressItem = OrderHistoryInfoView(
        title: SBLocalization.localized(key: ProfileText.OrderHistory.deliveryAddress))

    private lazy var paymentItem = OrderHistoryInfoView(
        title: SBLocalization.localized(key: ProfileText.OrderHistory.paymentDetails))

    private lazy var statusItem = OrderHistoryInfoView(
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

    private lazy var buttonStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 16
        return view
    }()

    private var orderedItems: [OrderHistoryItemView]?

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

        if orderStatus != .paid || orderStatus != .cooking || orderStatus != .inDelivery {
            var height = 43
            switch orderStatus {
            case .new:
                repeatOrderButton.setTitle("Отменить заказ", for: .normal)
                buttonStack.addArrangedSubview(repeatOrderButton)
            case .failure:
                buttonStack.addArrangedSubview(repeatOrderButton)
            case .issued:
                buttonStack.addArrangedSubview(sendCheckButton)
                buttonStack.addArrangedSubview(rateOrderButton)
                buttonStack.addArrangedSubview(repeatOrderButton)
                height = 161
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
                $0.height.equalTo(height)
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

        addressItem.configure(with: configureAddress(of: item.address))

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
        if itemStack.arrangedSubviews.isEmpty {
            var modifiersText = ""

            for item in items {
                if let price = item.position.price {
                    if !item.modifierGroups.isEmpty {
                        for m in item.modifierGroups {
                            for i in m.modifiers {
                                modifiersText = modifiersText.isEmpty ? i.position.name : modifiersText + ", " + i.position.name
                            }
                        }

                        itemStack.addArrangedSubview(OrderHistoryItemView(
                            with: "\(item.count)x \(item.position.name) (\(modifiersText))",
                            and: "\(Int(price)) ₸"
                        ))
                    } else {
                        itemStack.addArrangedSubview(OrderHistoryItemView(
                            with: "\(item.count)x \(item.position.name)",
                            and: "\(Int(price)) ₸"
                        ))
                    }
                }
            }

            deliveryItem.configure(with: SBLocalization.localized(key: ProfileText.OrderHistory.shipping), and: "\(Int(deliveryPrice)) ₸")
            sumItem.configure(with: SBLocalization.localized(key: ProfileText.OrderHistory.sum), and: "\(Int(totalSum)) ₸")

            itemStack.addArrangedSubview(deliveryItem)
            itemStack.addArrangedSubview(sumItem)
        }
    }

    private func getConvertedDate(of date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let convertedDate = dateFormatter.date(from: date)

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd.MM.yyyy, HH:mm"

        if let convertedDate = convertedDate {
            return dateFormatterPrint.string(from: convertedDate)
        } else {
            return ""
        }
    }

    private func configureAddress(of address: Address) -> String {
        var displayAddress = ""
        if let district = address.district {
            displayAddress.append(district)
        }
        if let street = address.street {
            displayAddress = displayAddress.isEmpty ? street : displayAddress + ", " + street
        }
        if let building = address.building {
            displayAddress = displayAddress.isEmpty ? building : displayAddress + ", " + building
        }
        if let corpus = address.corpus {
            displayAddress = displayAddress.isEmpty ? corpus : displayAddress + ", " + corpus
        }
        if let flat = address.flat {
            displayAddress = displayAddress.isEmpty ? flat : displayAddress + ", " + flat
        }
        return displayAddress
    }

    @objc private func rateOrder() {
        guard let orderNumber = orderNumber else { return }
        delegate?.rateOrder(at: orderNumber)
    }

    @objc private func shareToInstagram() {
        delegate?.shareToInstagramTapped()
    }
}
