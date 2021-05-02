//
//  BrandsController.swift
//  SalamBro
//
//  Created by Arystan on 3/7/21.
//

import Reusable
import RxCocoa
import RxSwift
import SnapKit
import UIKit

public final class BrandsController: UIViewController {
    private let viewModel: BrandViewModelProtocol
    private let disposeBag: DisposeBag

    private lazy var refreshControl: UIRefreshControl = {
        let action = UIRefreshControl()
        action.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return action
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: .init()
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(cellType: BrandCell.self)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    public init(viewModel: BrandViewModelProtocol) {
        self.viewModel = viewModel
        disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { nil }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
        setupNavigationBar()
    }

    private func bind() {
        viewModel.updateCollectionView
            .do { [unowned self] _ in
                let ratios = self.viewModel.ratios.map { (CGFloat($0.0), CGFloat($0.1)) }
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.collectionViewLayout = StagLayout(widthHeightRatios: ratios,
                                                                      itemSpacing: 16)
            }.bind(to: collectionView.rx.reload)
            .disposed(by: disposeBag)

        viewModel.isAnimating
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.addSubview(refreshControl)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.top.equalTo(view.snp.topMargin).offset(16)
            $0.bottom.equalTo(view.snp.bottomMargin)
        }
    }

    func setupNavigationBar() {
        navigationItem.title = L10n.Brands.Navigation.title
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black,
             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26)]
    }

    @objc
    func refresh(_: AnyObject) {
        viewModel.refresh()
    }
}

extension BrandsController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_: UICollectionView, didSelectItemAt _: IndexPath) {
        let vc = MapViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        viewModel.cellViewModels.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: BrandCell.self)
        cell.set(viewModel.cellViewModels[indexPath.row])
        return cell
    }

    public func collectionView(_: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt _: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.3) {
            cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell.layoutSubviews()
        }
    }
}
