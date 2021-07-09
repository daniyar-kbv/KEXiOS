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

final class BrandsController: UIViewController, AlertDisplayable {
    let outputs = Output()
    private let viewModel: BrandViewModelProtocol
    private let disposeBag: DisposeBag
    private let flowType: FlowType

    private lazy var refreshControl: UIRefreshControl = {
        let action = UIRefreshControl()
        action.addTarget(self, action: #selector(handleRefreshControlAction(_:)), for: .valueChanged)
        return action
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(cellType: BrandCell.self)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        return collectionView
    }()

    public init(viewModel: BrandViewModelProtocol,
                flowType: FlowType)
    {
        self.viewModel = viewModel
        self.flowType = flowType
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func bind() {
        viewModel.outputs.didGetBrands
            .do { [weak self] _ in
                guard let ratios = self?.viewModel.ratios else { return }
                self?.collectionView.collectionViewLayout.invalidateLayout()
                self?.collectionView.collectionViewLayout = StagLayout(widthHeightRatios: ratios,
                                                                       itemSpacing: 0)
            }.bind(to: collectionView.rx.reload)
            .disposed(by: disposeBag)

        viewModel.outputs.didFail.subscribe(onNext: { [weak self] error in
            self?.showError(error)
        }).disposed(by: disposeBag)

        viewModel.outputs.didSelectBrand.subscribe(onNext: { [weak self] brand in
            self?.outputs.didSelectBrand.accept(brand)
            if self?.flowType == .change {
                self?.dismiss(animated: true)
            }
        }).disposed(by: disposeBag)
    }

    private func setup() {
        setupViews()
        setupConstraints()

        navigationItem.title = L10n.Brands.Navigation.title
        setBackButton { [weak self] in
            self?.outputs.close.accept(())
        }
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalTo(view.snp.topMargin)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }

    @objc func handleRefreshControlAction(_: UIRefreshControl) {
        viewModel.getBrands()
        refreshControl.endRefreshing()
    }
}

extension BrandsController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelect(index: indexPath.row)
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

extension BrandsController: Reloadable {
    func reload() {
        viewModel.getBrands()
    }
}

extension BrandsController {
    enum FlowType: Equatable {
        case create
        case change
    }

    struct Output {
        let didSelectBrand = PublishRelay<Brand>()
        let close = PublishRelay<Void>()
    }
}
