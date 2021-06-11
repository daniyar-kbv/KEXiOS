//
//  TextField.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 07.05.2021.
//

import DropDown
import SnapKit
import UIKit

protocol DropDownTextFieldDelegate: AnyObject {
    func didSelect(dropDown: DropDownTextField, option: String, index: Int)
}

final class DropDownTextField: UIView {
    weak var delegate: DropDownTextFieldDelegate?
    private var type: Type
    
    var dataSource: [String] = [] {
        didSet {
            dropDown.dataSource = dataSource
        }
    }
    
    var isActive: Bool = true {
        didSet {
            self.isUserInteractionEnabled = isActive
            self.alpha = isActive ? 1 : 0.5
        }
    }

    override public var intrinsicContentSize: CGSize {
        let width = super.intrinsicContentSize.width
        let height = titleLabel.bounds.height + 6
            + contentLabel.bounds.height + 6
            + separatorView.bounds.height + 4
            + descriptionLabel.bounds.height
        return .init(width: width, height: height)
    }

    public var selectionAction: (() -> Void)?

    public var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    public var titleColor: UIColor? {
        get { contentLabel.textColor }
        set { contentLabel.textColor = newValue }
    }

    public var currentValue: String? {
        get { contentLabel.text }
        set {
            guard let newValue = newValue else {
                contentLabel.text = type.placeholder
                return
            }
            contentLabel.text = newValue
        }
    }

    public var descriptionText: String? {
        get { descriptionLabel.text }
        set { descriptionLabel.text = newValue }
    }

    public var chevronRight: Bool? {
        didSet {
            chevronImageView.transform = CGAffineTransform(rotationAngle: .pi * 1.5)
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .mildBlue
        label.text = type.title
        return label
    }()

    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .mildBlue
        label.text = type.placeholder
        return label
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .calmGray
        return view
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = .mildBlue
        label.numberOfLines = 0
        return label
    }()

    private lazy var chevronImageView: UIImageView = {
        let view = UIImageView()
        view.image = Asset.chevronBottom.image.withRenderingMode(.alwaysTemplate)
        view.tintColor = .mildBlue
        return view
    }()

    private lazy var dropDown: DropDown = {
        let dropDown = DropDown(anchorView: separatorView)
        dropDown.selectionAction = { [unowned self] index, item in
            self.currentValue = item
            self.delegate?.didSelect(dropDown: self, option: item, index: index)
        }
        dropDown.dataSource = dataSource
        dropDown.textFont = .systemFont(ofSize: 16, weight: .medium)
        dropDown.textColor = .darkGray
        dropDown.backgroundColor = .white
        dropDown.selectionBackgroundColor = .lightGray
        dropDown.shadowColor = UIColor.black.withAlphaComponent(0.07)
        dropDown.layer.cornerRadius = 4
        return dropDown
    }()

    public init(type: Type) {
        self.type = type
        
        super.init(frame: .zero)
        
        setup()
    }

    public required init?(coder _: NSCoder) { nil }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        [titleLabel, contentLabel, separatorView, chevronImageView, descriptionLabel].forEach { addSubview($0) }

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showDropDown))
        addGestureRecognizer(gestureRecognizer)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.right.lessThanOrEqualToSuperview()
        }

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.left.equalToSuperview()
            $0.right.lessThanOrEqualTo(chevronImageView.snp.left).offset(-8)
        }

        separatorView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(6)
            $0.height.equalTo(1)
            $0.left.right.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView).offset(4)
            $0.left.right.bottom.equalToSuperview()
        }

        chevronImageView.snp.makeConstraints {
            $0.centerY.equalTo(contentLabel.snp.centerY)
            $0.right.equalToSuperview()
            $0.height.width.equalTo(24)
        }
    }

    @objc
    private func showDropDown() {
        if let action = selectionAction {
            action()
        } else {
            dropDown.show()
        }
    }
}

extension DropDownTextField {
    enum `Type` {
        case country
        case city
        case address
        case brand
        
        var title: String {
            switch self {
            case .country:
                return L10n.SelectMainInfo.country
            case .city:
                return L10n.SelectMainInfo.city
            case .address:
                return L10n.SelectMainInfo.address
            case .brand:
                return L10n.SelectMainInfo.brand
            }
        }
        
        var placeholder: String {
            switch self {
            case .country:
                return L10n.CountriesList.Navigation.title
            case .city:
                return L10n.CitiesList.Navigation.title
            case .address:
//        Tech debt: change currentValue to appropriate localized text
                return L10n.SelectMainInfo.address
            case .brand:
                return L10n.Brands.Navigation.title
            }
        }
    }
}
