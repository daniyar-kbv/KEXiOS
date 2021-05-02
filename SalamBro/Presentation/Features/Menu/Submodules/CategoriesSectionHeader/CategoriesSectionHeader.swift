//
//  CategoriesSectionHeader.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Reusable

public final class CategoriesSectionHeader: UITableViewHeaderFooterView, Reusable {
    private var viewModel: CategoriesSectionHeaderViewModelProtocol! {
        didSet { bind() }
    }
    private var disposeBag = DisposeBag()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = .init(width: 200, height: 44)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(cellType: CategoryCell.self)
        view.dataSource = self
        view.delegate = self
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) { nil }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    public func set(_ viewModel: CategoriesSectionHeaderViewModelProtocol?) {
        self.viewModel = viewModel
    }
    
    private func bind() {
        
    }
    
    private func setup() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        contentView.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension CategoriesSectionHeader: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CategoryCell.self)
        cell.set(viewModel.cellViewModels[indexPath.row])
        return cell
    }
}
