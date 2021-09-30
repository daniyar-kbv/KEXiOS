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
        view.image =
            SBImageResource.getIcon(for: MenuIcons.Menu.dishPlaceholder)
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
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

    private lazy var sendCheckButton: SBSubmitButton = {
        let view = SBSubmitButton(style: .emptyBlack)
        view.setTitle(SBLocalization.localized(key: ProfileText.OrderHistory.sendBill),
                      for: .normal)
        view.snp.makeConstraints {
            $0.height.equalTo(43)
        }
        return view
    }()

    private lazy var rateOrderButton: SBSubmitButton = {
        let view = SBSubmitButton(style: .emptyRed)
        view.setTitle(SBLocalization.localized(key: ProfileText.OrderHistory.rateOrder),
                      for: .normal)
        view.snp.makeConstraints {
            $0.height.equalTo(43)
        }
        return view
    }()

    private lazy var repeatOrderButton: SBSubmitButton = {
        let view = SBSubmitButton(style: .emptyGray)
        view.setTitle(SBLocalization.localized(key: ProfileText.OrderHistory.repeatOrder),
                      for: .normal)
        view.snp.makeConstraints {
            $0.height.equalTo(43)
        }
        return view
    }()

    private lazy var buttonStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [sendCheckButton,
                                                  rateOrderButton,
                                                  repeatOrderButton])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 16
        return view
    }()

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

    func setDefaultLogo() {
        logoView.image =
            SBImageResource.getIcon(for: MenuIcons.Menu.dishPlaceholder)
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

        configureButtonStack()
    }

    func updateUI() {
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

    func configureButtonStack() {
//        MARK: Tech debt: uncomment when different order statuses exist

//        if orderStatus == .new || orderStatus == .failure || orderStatus == .issued {
//            switch orderStatus {
//            case .new:
//                sendCheckButton.isHidden = true
//                repeatOrderButton.isHidden = true
//                rateOrderButton.isHidden = true
//            case .failure:
//                sendCheckButton.isHidden = true
//                rateOrderButton.isHidden = true
//                repeatOrderButton.isHidden = false
//            case .issued:
        sendCheckButton.isHidden = false
        repeatOrderButton.isHidden = false
        rateOrderButton.isHidden = false
//            default:
//                return
//            }
        updateUI()
//        }
    }

    func configure(with item: OrdersList) {
        if let imageURL = URL(string: item.brand.image ?? "") {
            logoView.setImage(url: imageURL)
        }

        titleLabel.text = item.brand.name
        dateLabel.text = getConvertedDate(of: item.createdDate)
        checkNumberLabel.text = "№\(item.id)"

        configureItems(with: item.cart.items, deliveryPrice: Double(item.cart.deliveryPrice), totalSum: Double(item.cart.totalPrice))

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
        itemStack.arrangedSubviews
            .forEach { $0.removeFromSuperview() }

        items.forEach { item in
            var title = "\(item.count)x \(item.position.name)"

            if !item.modifierGroups.isEmpty {
                let modifiersText = item.modifierGroups
                    .map { $0.position.name }.joined(separator: ", ")
                title += " (\(modifiersText))"
            }

            if let price = item.position.price {
                itemStack.addArrangedSubview(OrderHistoryItemView(
                    with: title,
                    and: SBLocalization.localized(key: ProfileText.OrderHistory.price,
                                                  arguments: price.formattedWithSeparator)
                ))
            }
        }

        deliveryItem.configure(with: SBLocalization.localized(key: ProfileText.OrderHistory.shipping),
                               and: SBLocalization.localized(key: ProfileText.OrderHistory.price,
                                                             arguments: Int(deliveryPrice).formattedWithSeparator))
        sumItem.configure(with: SBLocalization.localized(key: ProfileText.OrderHistory.sum),
                          and: SBLocalization.localized(key: ProfileText.OrderHistory.price,
                                                        arguments: Int(totalSum).formattedWithSeparator))

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
