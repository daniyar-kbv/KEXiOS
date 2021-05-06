//
//  AddressPickerCell.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 07.05.2021.
//

import Reusable
import RxCocoa
import RxSwift
import SnapKit
import UIKit

public final class AddressPickerCell: UITableViewCell, Reusable {
    private var viewModel: AddressPickerCellViewModelProtocol! {
        didSet { bind() }
    }

    private var disposeBag: DisposeBag

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        disposeBag = DisposeBag()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public required init?(coder _: NSCoder) { nil }

    override public func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    public func set(viewModel: AddressPickerCellViewModelProtocol?) {
        self.viewModel = viewModel
    }

    private func bind() {
        viewModel.name.bind { [unowned self] in
            self.textLabel?.text = $0
        }.disposed(by: disposeBag)

        viewModel.isSelected.bind { [unowned self] in
            self.accessoryType = $0 ? .checkmark : .none
        }.disposed(by: disposeBag)
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        tintColor = .kexRed
        textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        textLabel?.textColor = .darkGray
    }

    private func setupConstraints() {}
}
