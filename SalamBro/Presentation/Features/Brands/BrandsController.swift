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

final class BrandsController: ViewController, AlertDisplayable {
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

    // MARK: Tech Debt - Need to implement swipe in iOS versions <= 12.0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = L10n.Brands.Navigation.title
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 26, weight: .regular),
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "chevron.left"), style: .plain, target: self, action: #selector(goBack))
    }

    private func bind() {
        viewModel.outputs.didGetBrands
            .do { [unowned self] _ in
                let ratios = self.viewModel.ratios.map { (CGFloat($0.0), CGFloat($0.1)) }
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.collectionViewLayout = StagLayout(widthHeightRatios: ratios,
                                                                      itemSpacing: 16)
            }.bind(to: collectionView.rx.reload)
            .disposed(by: disposeBag)

        viewModel.outputs.didGetError.subscribe(onNext: { [weak self] error in
            guard let error = error else { return }
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
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        collectionView.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 24, right: 0)
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

    @objc func goBack() {
        if navigationController?.presentingViewController != nil {
            dismiss(animated: true, completion: nil)
            return
        }

        navigationController?.popViewController(animated: true)
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

extension BrandsController {
    enum FlowType: Equatable {
        case create
        case change
    }

    struct Output {
        let didSelectBrand = PublishRelay<Brand>()
    }
}
