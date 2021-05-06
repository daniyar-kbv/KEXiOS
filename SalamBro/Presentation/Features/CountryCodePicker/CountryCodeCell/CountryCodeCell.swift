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

public final class CountryCodeCell: UITableViewCell, Reusable {
    private var viewModel: CountryCodeCellViewModelProtocol! {
        didSet { bind() }
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

    public func set(_ viewModel: CountryCodeCellViewModelProtocol?) {
        self.viewModel = viewModel
    }

    private func bind() {
        viewModel.title.bind { [unowned self] in
            self.textLabel?.text = $0
        }.disposed(by: disposeBag)

        viewModel.isSelected.bind { [unowned self] in
            self.accessoryView = $0 ? checkmark : UIView()
        }.disposed(by: disposeBag)
    }

    private func setup() {
        backgroundColor = .white
        tintColor = .kexRed
        selectionStyle = .none
    }
}
