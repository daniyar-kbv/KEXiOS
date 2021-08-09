//
//  AdCell.swift
//  SalamBro
//
//  Created by Arystan on 4/28/21.
//

import Imaginary
import Reusable
import RxCocoa
import RxSwift
import UIKit

final class AdCell: UICollectionViewCell, Reusable {
    private var viewModel: AdCellViewModelProtocol! {
        didSet { bind() }
    }

    private var disposeBag = DisposeBag()

    private let adImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 9
        return view
    }()

    override init(frame _: CGRect) {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder _: NSCoder) { nil }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func set(_ viewModel: AdCellViewModelProtocol?) {
        self.viewModel = viewModel
    }

    private func bind() {
        viewModel.promotionImageURL.bind(onNext: { [weak self] urlString in
            guard let url = URL(string: urlString ?? "") else { return }
            print(urlString)
            print(url)
            self?.adImageView.setImage(url: url)
        }).disposed(by: disposeBag)
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        contentView.addSubview(adImageView)
    }

    private func setupConstraints() {
        adImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
