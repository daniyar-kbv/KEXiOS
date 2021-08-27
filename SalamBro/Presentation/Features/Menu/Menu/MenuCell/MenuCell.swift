//
//  MenuCell.swift
//  SalamBro
//
//  Created by Arystan on 4/23/21.
//

import Imaginary
import Reusable
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class MenuCell: UITableViewCell, Reusable {
    private lazy var foodImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.numberOfLines = 0
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .mildBlue
        return label
    }()

    private lazy var button: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        button.setTitleColor(.kexRed, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.kexRed.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 11)
        button.isUserInteractionEnabled = false
        return button
    }()

    private let unavaiLableLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .kexRed
        return label
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            self.titleLabel,
            self.descriptionLabel,
            self.button,
            self.unavaiLableLabel,
        ])
        view.spacing = 4
        view.alignment = .leading
        view.distribution = .equalSpacing
        view.axis = .vertical
        return view
    }()

    private var viewModel: MenuCellViewModelProtocol! {
        didSet {
            bind()
            viewModel.reload()
        }
    }

    private var disposeBag = DisposeBag()

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public required init?(coder _: NSCoder) { nil }

    override public func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    func set(_ viewModel: MenuCellViewModelProtocol?) {
        self.viewModel = viewModel
    }

    private func bind() {
        viewModel.itemImageURL
            .bind(onNext: { [weak self] imageURL in
                guard let url = imageURL else {
                    self?.foodImageView.image = nil
                    return
                }
                self?.foodImageView.setImage(url: url)
            })
            .disposed(by: disposeBag)

        viewModel.itemTitle
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.itemDescription
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.itemStatus
            .bind(onNext: { [weak self] status in
                guard let status = status else { return }
                self?.configureStatus(for: status)
            })
            .disposed(by: disposeBag)

        viewModel.itemPrice
            .bind(to: button.rx.title())
            .disposed(by: disposeBag)
    }

    private func setup() {
        setupCell()
        setupViews()
        setupConstraints()
    }

    private func configureStatus(for status: Bool) {
        unavaiLableLabel.text = SBLocalization.localized(key: MenuText.Menu.MenuItem.unavailable)
        unavaiLableLabel.isHidden = status
        button.isHidden = !status
        isUserInteractionEnabled = status
    }

    private func setupCell() {
        selectionStyle = .none
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
