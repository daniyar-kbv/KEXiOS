//
//  AdCollectionCell.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/16/21.
//

import Reusable
import RxCocoa
import RxSwift
import UIKit

final class AdCollectionCell: UITableViewCell {
    public var delegate: AddCollectionCellDelegate?

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(cellType: AdCell.self)
        return collectionView
    }()

    private var viewModel: AdCollectionCellViewModelProtocol! {
        didSet { bind() }
    }

    private var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
        selectionStyle = .none
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    public func set(_ viewModel: AdCollectionCellViewModelProtocol?) {
        self.viewModel = viewModel
    }

    private func bind() {}
}

extension AdCollectionCell {
    private func layoutUI() {
        contentView.addSubview(collectionView)

        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-8)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(112)
        }
    }
}

extension AdCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let promotionURL = URL(string: viewModel.cellViewModels[indexPath.item].promotion.link ?? "") else { return }
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        delegate?.openPromotion(promotionURL: promotionURL,
                                name: viewModel.cellViewModels[indexPath.item].promotion.name)
    }

    public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.cellViewModels.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AdCell.self)
        cell.set(viewModel.cellViewModels[indexPath.row])
        return cell
    }

    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width * 0.8
        let height: CGFloat = 112
        return CGSize(width: width, height: height)
    }
}

extension AdCollectionCell: Reusable {}

public protocol AddCollectionCellDelegate {
    func openPromotion(promotionURL: URL, name: String)
}
