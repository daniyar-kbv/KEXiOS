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

public protocol BrandsControllerDelegate: AnyObject {
    func didSelectBrand(controller: BrandsController, brand: BrandUI)
}

public final class BrandsController: UIViewController {
    private let viewModel: BrandViewModelProtocol
    private let disposeBag: DisposeBag

    public weak var delegate: BrandsControllerDelegate?

    private lazy var refreshControl: UIRefreshControl = {
        let action = UIRefreshControl()
        action.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return action
    }()

    private lazy var navbar = CustomNavigationBarView(navigationTitle: L10n.Brands.Navigation.title)

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
        collectionView.refreshControl = refreshControl
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
        view.addSubview(navbar)
        view.addSubview(collectionView)
        navbar.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navbar.titleLabel.font = .systemFont(ofSize: 26, weight: .regular)
    }

    private func setupConstraints() {
        navbar.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
        }

        collectionView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.top.equalTo(navbar.snp.bottom).offset(8)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }

    @objc func refresh(_: AnyObject) {
        viewModel.refresh()
    }

    @objc func backButtonTapped() {
        // TODO:
        if presentingViewController == nil {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}

extension BrandsController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO:
        let brand = viewModel.didSelect(index: indexPath.row)
        delegate?.didSelectBrand(controller: self,
                                 brand: brand)
        if presentingViewController == nil {
            let vc = MapViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            dismiss(animated: true)
        }
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
