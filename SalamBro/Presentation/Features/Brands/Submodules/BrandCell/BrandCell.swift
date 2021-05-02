//
//  BrandCell.swift
//  SalamBro
//
//  Created by Arystan on 4/7/21.
//

import Reusable
import RxCocoa
import RxSwift
import SnapKit
import UIKit

public final class BrandCell: UICollectionViewCell, Reusable {
    private var viewModel: BrandCellViewModelProtocol! {
        didSet { bind() }
    }

    private var disposeBag = DisposeBag()

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder _: NSCoder) { nil }

    override public func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    public func set(_ viewModel: BrandCellViewModelProtocol?) {
        self.viewModel = viewModel
    }

    private func bind() {
        viewModel.name
            .map { UIImage(named: $0) }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        backgroundColor = .clear
        layer.cornerRadius = 16
        layer.masksToBounds = true
        contentView.addSubview(imageView)
    }

    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
