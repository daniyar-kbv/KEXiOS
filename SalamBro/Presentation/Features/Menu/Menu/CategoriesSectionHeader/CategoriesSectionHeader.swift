//
//  CategoriesSectionHeader.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Reusable
import RxCocoa
import RxSwift
import SnapKit
import UIKit

public final class CategoriesSectionHeader: UITableViewHeaderFooterView, Reusable {
    private var viewModel: CategoriesSectionHeaderViewModelProtocol! {
        didSet {
            collectionView.reloadData()
            collectionView.selectItem(at: .init(row: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        }
    }

    private var disposeBag = DisposeBag()
    weak var scrollService: MenuScrollService? {
        didSet {
            bindScrollService()
        }
    }

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

    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setup()
    }

    required init?(coder _: NSCoder) { nil }

    override public func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func set(_ viewModel: CategoriesSectionHeaderViewModelProtocol?) {
        self.viewModel = viewModel
    }

    private func bindScrollService() {
        scrollService?.didSelectCategory
            .subscribe(onNext: { [weak self] source, category in
                switch source {
                case .table:
                    self?.select(category: category)
                case .header:
                    self?.scroll(to: category)
                }
            })
            .disposed(by: disposeBag)
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
    public func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let categoryUUID = viewModel.getCategory(by: indexPath.item) else { return }
        scrollService?.didSelectCategory.accept((source: .header, categoryUUID: categoryUUID))
    }

    public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.cellViewModels.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CategoryCell.self)
        cell.set(viewModel.cellViewModels[indexPath.row])
        return cell
    }
}

extension CategoriesSectionHeader {
    func select(category: String) {
        guard scrollService?.isHeaderScrolling == false,
              let index = viewModel.getIndex(of: category)
        else { return }
        collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }

    func scroll(to category: String) {
        guard let index = viewModel.getIndex(of: category) else { return }
        scrollService?.startedScrolling()
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension CategoriesSectionHeader: UIScrollViewDelegate {
    public func scrollViewDidEndScrollingAnimation(_: UIScrollView) {
        scrollService?.finishedScrolling()
    }
}
