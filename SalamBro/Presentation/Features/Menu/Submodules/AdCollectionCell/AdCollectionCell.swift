//
//  AdCollectionCell.swift
//  SalamBro
//
//  Created by Arystan on 4/27/21.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

public final class AdCollectionCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel: AdCollectionCellViewModelProtocol! {
        didSet { bind() }
    }
    private var disposeBag = DisposeBag()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        layout.scrollDirection = .horizontal
        
        collectionView.bounces = false
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(cellType: AdCell.self)
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public override func prepareForReuse() {
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
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AdCell.self)
        cell.set(viewModel.cellViewModels[indexPath.row])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat
        let height: CGFloat
        width = 312
        height = 112
        return .init(width: width, height: height)
    }
}
