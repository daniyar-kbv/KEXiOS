//
//  OrderTestCell.swift
//  SalamBro
//
//  Created by Arystan on 5/5/21.
//

import Reusable
import SnapKit
import UIKit

public final class OrderTestCell: UITableViewCell, Reusable {
    var delegate: OrderHistoryDelegate?

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

    lazy var orderInfoStack: UIStackView = {
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
        view.addTarget(self, action: #selector(shareToInstagram), for: .touchUpInside)
        return view
    }()

    lazy var item1Label: UILabel = {
        let view = UILabel()
        view.text = "1x BIG COMBO (Pepsi 0,5)"
        return view
    }()

    lazy var item2Label: UILabel = {
        let view = UILabel()
        view.text = "2x Чизбургер куриный"
        return view
    }()

    lazy var deliveryLabel: UILabel = {
        let view = UILabel()
        view.text = "Доставка"
        return view
    }()

    lazy var totalLabel: UILabel = {
        let view = UILabel()
        view.text = "Итого:"
        return view
    }()

    lazy var item1PriceLabel: UILabel = {
        let view = UILabel()
        view.text = "1 490 ₸"
        view.textAlignment = .right
        return view
    }()

    lazy var item2PriceLabel: UILabel = {
        let view = UILabel()
        view.text = "780 ₸"
        view.textAlignment = .right
        return view
    }()

    lazy var deliveryPriceLabel: UILabel = {
        let view = UILabel()
        view.text = "500 ₸"
        view.textAlignment = .right
        return view
    }()

    lazy var totalPriceLabel: UILabel = {
        let view = UILabel()
        view.text = "2 770 ₸"
        view.textAlignment = .right
        return view
    }()

    lazy var priceStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.spacing = 8
        return view
    }()

    lazy var sendCheckButon: UIButton = {
        let view = UIButton()
        view.setTitle("Отправить чек на почту", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.setTitleColor(.black, for: .normal)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()

    lazy var deliveryAddressTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "Адрес доставки"
        view.textColor = .mildBlue
        view.font = .systemFont(ofSize: 10, weight: .medium)
        return view
    }()

    lazy var deliveryAddressLabel: UILabel = {
        let view = UILabel()
        view.text = "мкр. Орбита 1, 41"
        return view
    }()

    lazy var paymentTitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .mildBlue
        view.font = .systemFont(ofSize: 10, weight: .medium)
        view.text = "Детали оплаты"
        return view
    }()

    lazy var paymentLabel: UILabel = {
        let view = UILabel()
        view.text = "Картой в приложении"
        return view
    }()

    lazy var orderStatusTitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .mildBlue
        view.font = .systemFont(ofSize: 10, weight: .medium)
        view.text = "Статус заказа"
        return view
    }()

    lazy var orderStatusLabel: UILabel = {
        let view = UILabel()
        view.text = "Доставлен"
        return view
    }()

    lazy var rateOrderButton: UIButton = {
        let view = UIButton()
        view.setTitle("Оценить заказ", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.setTitleColor(.kexRed, for: .normal)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.kexRed.cgColor
        view.layer.borderWidth = 1
        view.addTarget(self, action: #selector(rateOrder), for: .touchUpInside)
        return view
    }()

    lazy var repeatOrderButton: UIButton = {
        let view = UIButton()
        view.setTitle("Повторить заказ", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.setTitleColor(.mildBlue, for: .normal)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.mildBlue.cgColor
        view.layer.borderWidth = 1
        return view
    }()

    lazy var stack1 = UIStackView(arrangedSubviews: [item1Label, item1PriceLabel])
    lazy var stack2 = UIStackView(arrangedSubviews: [item2Label, item2PriceLabel])
    lazy var stack3 = UIStackView(arrangedSubviews: [deliveryLabel, deliveryPriceLabel])
    lazy var stack4 = UIStackView(arrangedSubviews: [totalLabel, totalPriceLabel])

    lazy var topView = UIView()

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public required init?(coder _: NSCoder) { nil }

    override public func prepareForReuse() {
        super.prepareForReuse()
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        [stack1, stack2, stack3, stack4].forEach {
            priceStack.addArrangedSubview($0)
        }

        [logoView, orderInfoStack, shareToInstagramButton, priceStack, sendCheckButon, deliveryAddressTitleLabel, deliveryAddressLabel, paymentTitleLabel, paymentLabel, orderStatusTitleLabel, orderStatusLabel, rateOrderButton, repeatOrderButton].forEach { contentView.addSubview($0) }
    }

    private func setupConstraints() {
        stack1.snp.makeConstraints { $0.left.right.equalToSuperview() }
        stack2.snp.makeConstraints { $0.left.right.equalToSuperview() }
        stack3.snp.makeConstraints { $0.left.right.equalToSuperview() }
        stack4.snp.makeConstraints { $0.left.right.equalToSuperview() }

        logoView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.left.equalToSuperview()
            $0.height.equalTo(48)
            $0.width.equalTo(48)
        }

        orderInfoStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.left.equalTo(logoView.snp.right).offset(16)
            $0.right.equalTo(shareToInstagramButton.snp.left).offset(-16)
        }

        shareToInstagramButton.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalTo(logoView.snp.centerY)
            $0.height.equalTo(36)
            $0.width.equalTo(107)
        }

        priceStack.snp.makeConstraints {
            $0.top.equalTo(orderInfoStack.snp.bottom).offset(16)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }

        deliveryAddressTitleLabel.snp.makeConstraints {
            $0.top.equalTo(priceStack.snp.bottom).offset(16)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }
        deliveryAddressLabel.snp.makeConstraints {
            $0.top.equalTo(deliveryAddressTitleLabel.snp.bottom).offset(4)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }

        paymentTitleLabel.snp.makeConstraints {
            $0.top.equalTo(deliveryAddressLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }

        paymentLabel.snp.makeConstraints {
            $0.top.equalTo(paymentTitleLabel.snp.bottom).offset(4)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }

        orderStatusTitleLabel.snp.makeConstraints {
            $0.top.equalTo(paymentLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }

        orderStatusLabel.snp.makeConstraints {
            $0.top.equalTo(orderStatusTitleLabel.snp.bottom).offset(4)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }

        sendCheckButon.snp.makeConstraints {
            $0.top.equalTo(orderStatusLabel.snp.bottom).offset(16)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(43)
        }

        rateOrderButton.snp.makeConstraints {
            $0.top.equalTo(sendCheckButon.snp.bottom).offset(16)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(43)
        }

        repeatOrderButton.snp.makeConstraints {
            $0.top.equalTo(rateOrderButton.snp.bottom).offset(16)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
            $0.height.equalTo(43)
        }
    }

    @objc func rateOrder() {
        delegate?.rate()
    }

    @objc func shareToInstagram() {
        delegate?.share()
    }
}
