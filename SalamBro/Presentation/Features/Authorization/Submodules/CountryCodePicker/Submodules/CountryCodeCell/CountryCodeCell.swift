//
//  CountryCodeCell.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import SnapKit
import UIKit

struct CountryCodeModel {
    let country: Country
    var isSelected: Bool
}

final class CountryCodeCell: UITableViewCell {
    static let reuseIdentifier: String = "CountryCodeCell"

    private lazy var codeLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .medium)
        return view
    }()

    private lazy var countryLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.textColor = .mildBlue
        return view
    }()

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public required init?(coder _: NSCoder) { nil }

    override public func prepareForReuse() {
        super.prepareForReuse()
    }

    func configure(model: CountryCodeModel) {
        countryLabel.text = model.country.name
        codeLabel.text = model.country.countryCode
        accessoryType = model.isSelected ? .checkmark : .none
    }

    private func bind() {
//        viewModel.title.bind { [unowned self] in
//            self.countryLabel.text = $0
//        }.disposed(by: disposeBag)
//
//        viewModel.code.bind { [unowned self] in
//            self.codeLabel.text = $0
//        }.disposed(by: disposeBag)
//
//        viewModel.isSelected.bind { [unowned self] in
//            self.accessoryView = $0 ? checkmark : .none
//        }.disposed(by: disposeBag)
    }

    private func setup() {
        backgroundColor = .white
        tintColor = .kexRed
        selectionStyle = .none
        contentView.addSubview(codeLabel)
        contentView.addSubview(countryLabel)
        setupConstraints()
    }

    private func setupConstraints() {
        codeLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
        }

        countryLabel.snp.makeConstraints {
            $0.left.equalTo(codeLabel.snp.right).offset(32)
            $0.centerY.equalToSuperview()
        }
    }
}
