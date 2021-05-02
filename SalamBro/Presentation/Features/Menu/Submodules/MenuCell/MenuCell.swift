//
//  MenuCell.swift
//  SalamBro
//
//  Created by Arystan on 4/23/21.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable
import SnapKit

public final class MenuCell: UITableViewCell, Reusable {
    
    private lazy var foodImageView: UIImageView = {
        let view = UIImageView()
        view.image = Asset.fastFood.image
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        button.setTitleColor(.kexRed, for: .normal)
        button.titleLabel?.textAlignment = .left
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            self.titleLabel,
            self.descriptionLabel,
            self.button
        ])
        view.spacing = 4
        view.alignment = .leading
        view.distribution = .fill
        view.axis = .vertical
        return view
    }()
    
    private var viewModel: MenuCellViewModelProtocol! {
        didSet { bind() }
    }
    private var disposeBag = DisposeBag()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    public required init?(coder: NSCoder) { nil }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    public func set(_ viewModel: MenuCellViewModelProtocol?) {
        self.viewModel = viewModel
    }
    
    private func bind() {
        viewModel.itemTitle
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.itemDescription
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.itemPrice
            .bind(to: button.rx.title())
            .disposed(by: disposeBag)
    }
    
    private func setup() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        [foodImageView, stackView].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        foodImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalToSuperview().offset(24)
            $0.bottom.lessThanOrEqualToSuperview().offset(-16)
            $0.size.equalTo(CGSize(width: 115, height: 100))
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalTo(foodImageView.snp.right).offset(8)
            $0.right.bottom.equalToSuperview().offset(-16)
        }
    }
}
