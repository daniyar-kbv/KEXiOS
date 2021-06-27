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
    func rateOrderTapped()
}

final class OrderHistoryCellContentView: UIView {
    weak var delegate: OrderHistoryViewDelegate?

    private lazy var logoView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "SalamBro4")
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Salam Bro"
        view.font = .systemFont(ofSize: 14)
        return view
    }()

    private lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.text = "02.03.21, 17:30"
        view.textColor = .mildBlue
        view.font = .systemFont(ofSize: 14)
        return view
    }()

    private lazy var checkNumberLabel: UILabel = {
        let view = UILabel()
        view.text = "№53150756"
        view.font = .systemFont(ofSize: 10, weight: .medium)
        view.textColor = .mildBlue
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
        view.setImage(UIImage(named: "shareToInstagram"), for: .normal)
        return view
    }()

    private lazy var item1 = OrderHistoryItemView(title: "1x BIG COMBO (Pepsi 0,5)", price: "1 490 ₸")
    private lazy var item2 = OrderHistoryItemView(title: "2x Чизбургер куриный", price: "780 ₸")
    private lazy var deliveryItem = OrderHistoryItemView(title: "Доставка", price: "500")
    private lazy var sumItem = OrderHistoryItemView(title: "Итого", price: "2770")

    private lazy var itemStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            item1,
            item2,
            deliveryItem,
            sumItem,
        ])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 8
        return view
    }()

    private lazy var addressItem = OrderHistoryInfoView(title: "Адрес доставки", info: "мкр. Орбита 1, 41")
    private lazy var paymentItem = OrderHistoryInfoView(title: "Детали оплаты", info: "Картой в приложении")
    private lazy var statusItem = OrderHistoryInfoView(title: "Статус заказа", info: "Доставлен")

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

    private lazy var sendCheckButton = OrderHistoryButton(color: .black, titleString: "Отправить чек на почту")
    private lazy var rateOrderButton = OrderHistoryButton(color: .kexRed, titleString: "Оценить заказ")
    private lazy var repeatOrderButton = OrderHistoryButton(color: .mildBlue, titleString: "Повторить заказ")

    private lazy var buttonStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            sendCheckButton,
            rateOrderButton,
            repeatOrderButton,
        ])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 16
        return view
    }()

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
        }

        addSubview(buttonStack)
        buttonStack.snp.makeConstraints {
            $0.top.equalTo(infoStack.snp.bottom).offset(16)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-24)
            $0.height.equalTo(161)
        }
    }

    @objc private func rateOrder() {
        delegate?.rateOrderTapped()
    }

    @objc private func shareToInstagram() {
        delegate?.shareToInstagramTapped()
    }
}
