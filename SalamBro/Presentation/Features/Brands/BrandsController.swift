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

final class BrandsController: ViewController {
    private let viewModel: BrandViewModelProtocol
    private let disposeBag: DisposeBag

    private lazy var refreshControl: UIRefreshControl = {
        let action = UIRefreshControl()
        action.addTarget(self, action: #selector(handleRefreshControlAction(_:)), for: .valueChanged)
        return action
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: .init()
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
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
        viewModel.getBrands()
    }

    // MARK: Tech Debt - Need to implement swipe in iOS versions <= 12.0

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationItem.title = L10n.Brands.Navigation.title
//        navigationController?.navigationBar.titleTextAttributes = [
//            .font: UIFont.systemFont(ofSize: 26, weight: .regular),
//        ]
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "chevron.left"), style: .plain, target: self, action: #selector(goBack))
//    }

    private func bind() {
        viewModel.updateCollectionView
            .do { [unowned self] _ in
                let ratios = self.viewModel.ratios.map { (CGFloat($0.0), CGFloat($0.1)) }
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.collectionViewLayout = StagLayout(widthHeightRatios: ratios,
                                                                      itemSpacing: 16)
            }.bind(to: collectionView.rx.reload)
            .disposed(by: disposeBag)
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = L10n.Brands.Navigation.title
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 26, weight: .regular),
        ]
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        collectionView.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0)
        collectionView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(view.snp.topMargin)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }

    @objc func handleRefreshControlAction(_: UIRefreshControl) {
        viewModel.refreshBrands()
        refreshControl.endRefreshing()
    }

//    @objc func goBack() {
//        dismiss(animated: true, completion: nil)
//        navigationController?.popViewController(animated: true)
//    }
}

extension BrandsController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelect(index: indexPath.row) { [weak self] type in
            guard let type = type as? AddressCoordinator.FlowType else { return }
            switch type {
            case .changeAddress, .changeMainInfo:
                self?.dismiss(animated: true)
            default:
                break
            }
        }
    }

    public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        viewModel.brands.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: BrandCell.self)
        let brand = viewModel.brands[indexPath.row]
        cell.configure(brand: brand)
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
