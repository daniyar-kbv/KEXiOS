//
//  AdCollectionCell.swift
//  SalamBro
//
//  Created by Arystan on 4/27/21.
//

import Reusable
import RxCocoa
import RxSwift
import UIKit

public final class AdCollectionCell: UITableViewCell, NibReusable {
    public var delegate: AddCollectionCellDelegate?

    @IBOutlet var collectionView: UICollectionView!

    private var viewModel: AdCollectionCellViewModelProtocol! {
        didSet { bind() }
    }

    private var disposeBag = DisposeBag()

    override public func awakeFromNib() {
        super.awakeFromNib()

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(cellType: AdCell.self)
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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

extension AdCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        delegate?.goToRating()
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

public protocol AddCollectionCellDelegate {
    func goToRating()
}
