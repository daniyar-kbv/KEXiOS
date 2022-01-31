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
import Spruce
import UIKit

final class BrandsController: UIViewController {
    let outputs = Output()
    private let viewModel: BrandViewModelProtocol
    private let disposeBag = DisposeBag()

    let animations: [StockAnimation] = [.expand(.moderately), .fadeIn]
    var sortFunction: SortFunction = RandomSortFunction(interObjectDelay: 0.05)

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

    public init(viewModel: BrandViewModelProtocol) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { nil }

    override public func viewDidLoad() {
        super.viewDidLoad()

        collectionView.spruce.prepare(with: animations)
        layoutUI()
        bind()
        viewModel.getBrands()
    }

    private func bind() {
        viewModel.outputs.didGetBrands
            .subscribe(onNext: { [weak self] in
                self?.callAnimation()
                guard let ratios = self?.viewModel.ratios else { return }
                self?.collectionView.collectionViewLayout.invalidateLayout()
                self?.collectionView.collectionViewLayout = StagLayout(widthHeightRatios: ratios,
                                                                       itemSpacing: 0)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.didRefreshCollectionView
            .bind(to: collectionView.rx.reload)
            .disposed(by: disposeBag)

        viewModel.outputs.didFail.subscribe(onNext: { [weak self] error in
            self?.showError(error)
        }).disposed(by: disposeBag)

        viewModel.outputs.didSelectBrand
            .bind(to: outputs.didSelectBrand)
            .disposed(by: disposeBag)

        viewModel.outputs.toMap
            .bind(to: outputs.toMap)
            .disposed(by: disposeBag)
    }

    private func layoutUI() {
        navigationItem.title = SBLocalization.localized(key: AddressText.Brands.title)
        setBackButton { [weak self] in
            self?.outputs.close.accept(())
        }

        view.backgroundColor = .arcticWhite
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalTo(view.snp.topMargin)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }

    @objc func handleRefreshControlAction(_: UIRefreshControl) {
        viewModel.getBrands()
        refreshControl.endRefreshing()
        callAnimation()
    }

    private func callAnimation() {
        let animation = SpringAnimation(duration: 0.7)
        DispatchQueue.main.async {
            self.collectionView.spruce.animate(self.animations, animationType: animation, sortFunction: self.sortFunction)
        }
    }
}

extension BrandsController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let firstAction = UIAlertAction(
            title: SBLocalization.localized(key: AddressText.SelectMainInfo.Alert.actionYes),
            style: .default,
            handler: { [weak self] _ in
                self?.viewModel.didSelect(index: indexPath.row)
            }
        )

        let secondAction = UIAlertAction(
            title: SBLocalization.localized(key: AddressText.SelectMainInfo.Alert.actionNo),
            style: .default,
            handler: nil
        )

        showAlert(title: SBLocalization.localized(key: AddressText.SelectMainInfo.Alert.title),
                  message: SBLocalization.localized(key: AddressText.SelectMainInfo.Alert.bodyBrand),
                  actions: [firstAction, secondAction])
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
}

extension BrandsController: Reloadable {
    func reload() {
        viewModel.getBrands()
    }
}

extension BrandsController {
    struct Output {
        let didSelectBrand = PublishRelay<Brand>()
        let toMap = PublishRelay<UserAddress>()
        let close = PublishRelay<Void>()
    }
}
