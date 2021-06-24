//
//  OrderHistoryCellTopView.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/23/21.
//

import SnapKit
import UIKit

final class OrderHistoryCellContentView: UIView {
    lazy var logoView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "SalamBro4")
        return view
    }()

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Salam Bro"
        view.font = .systemFont(ofSize: 14)
        return view
    }()

    lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.text = "02.03.21, 17:30"
        view.textColor = .mildBlue
        view.font = .systemFont(ofSize: 14)
        return view
    }()

    lazy var checkNumberLabel: UILabel = {
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

    lazy var shareToInstagramButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "shareToInstagram"), for: .normal)
        return view
    }()

    lazy var item1 = OrderHistoryItemView(title: "1x BIG COMBO (Pepsi 0,5)", price: "1 490 ₸")
    lazy var item2 = OrderHistoryItemView(title: "2x Чизбургер куриный", price: "780 ₸")
    lazy var deliveryItem = OrderHistoryItemView(title: "Доставка", price: "500")
    lazy var sumItem = OrderHistoryItemView(title: "Итого", price: "2770")

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

    lazy var addressItem = OrderHistoryInfoView(title: "Адрес доставки", info: "мкр. Орбита 1, 41")
    lazy var paymentItem = OrderHistoryInfoView(title: "Детали оплаты", info: "Картой в приложении")
    lazy var statusItem = OrderHistoryInfoView(title: "Статус заказа", info: "Доставлен")

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

    lazy var sendCheckButton = OrderHistoryButton(color: .black, titleString: "Отправить чек на почту")
    lazy var rateOrderButton = OrderHistoryButton(color: .kexRed, titleString: "Оценить заказ")
    lazy var repeatOrderButton = OrderHistoryButton(color: .mildBlue, titleString: "Повторить заказ")

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

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {
        [logoView, orderInfoStack, shareToInstagramButton].forEach {
            addSubview($0)
        }
        logoView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(24)
            $0.left.equalToSuperview()
            $0.height.equalTo(48)
            $0.width.equalTo(48)
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
}
