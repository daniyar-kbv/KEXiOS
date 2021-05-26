//
//  CountryCodeCell.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Reusable
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class CountryCodeCell: UITableViewCell, Reusable {
    private var viewModel: CountryCodeCellViewModelProtocol! {
        didSet { bind() }
    }

    private var disposeBag = DisposeBag()

    private lazy var codeLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .medium)
        return view
    }()

    private lazy var countryLabel: UILabel = {
        let view = UILabel()
        view.text = "text"
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
        disposeBag = DisposeBag()
    }

    func set(_ viewModel: CountryCodeCellViewModelProtocol?) {
        self.viewModel = viewModel
    }

    private func bind() {
        viewModel.title.bind { [unowned self] in
            self.countryLabel.text = $0
        }.disposed(by: disposeBag)

        viewModel.code.bind { [unowned self] in
            self.codeLabel.text = $0
        }.disposed(by: disposeBag)

        viewModel.isSelected.bind { [unowned self] in
            self.accessoryView = $0 ? checkmark : .none
        }.disposed(by: disposeBag)
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
            $0.left.centerY.equalToSuperview()
        }

        countryLabel.snp.makeConstraints {
            $0.left.equalTo(codeLabel.snp.right).offset(32)
            $0.centerY.equalToSuperview()
        }
    }
}
