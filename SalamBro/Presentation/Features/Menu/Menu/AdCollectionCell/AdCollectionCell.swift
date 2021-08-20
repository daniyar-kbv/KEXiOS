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
    weak var delegate: AddCollectionCellDelegate?

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 24, bottom: 8, right: 24)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 312, height: 112)
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
            $0.edges.equalToSuperview()
            $0.height.equalTo(136)
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

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate _: Bool) {
        let targetContentOffset = scrollView.contentOffset
        let pageWidth = collectionView.bounds.size.width
        let minSpace: CGFloat = 24

        var cellToSwipe = Int(targetContentOffset.x / (pageWidth + minSpace) + 0.5)
        if cellToSwipe < 0 {
            cellToSwipe = 0
        } else if cellToSwipe >= collectionView.numberOfItems(inSection: 0) {
            cellToSwipe = collectionView.numberOfItems(inSection: 0) - 1
        }

        collectionView.scrollToItem(at: .init(item: cellToSwipe, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension AdCollectionCell: Reusable {}

public protocol AddCollectionCellDelegate: AnyObject {
    func openPromotion(promotionURL: URL, name: String)
}
