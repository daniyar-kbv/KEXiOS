//
//  AdditionalItemChooseController.swift
//  DetailView
//
//  Created by Arystan on 5/1/21.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class ModifiersController: UIViewController {
    private let viewModel: ModifiersViewModel
    private let disposeBag = DisposeBag()

    let outputs = Output()

    init(viewModel: ModifiersViewModel) {
        self.viewModel = viewModel

        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private(set) lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let view = UICollectionViewFlowLayout()
        view.scrollDirection = .vertical
        return view
    }()

    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(cellType: ModifiersCell.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .arcticWhite
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    override func loadView() {
        super.loadView()

        view = collectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.outputs.groupName
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        viewModel.outputs.update
            .bind(to: collectionView.rx.reload)
            .disposed(by: disposeBag)
    }

    private func getSize() -> CGSize {
        let freeWidth = UIScreen.main.bounds.width - 56
        let cellWidth = freeWidth / 2
        let cellHeight = cellWidth * (195 / 160)
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension ModifiersController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.modifiers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ModifiersCell.self)
        cell.configure(modifier: viewModel.modifiers[indexPath.row], index: indexPath.row)
        cell.configureUI(with: viewModel.getCellStatus(at: indexPath.row))
        cell.delegate = self
        return cell
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        getSize()
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 16
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 8
    }
}

extension ModifiersController: ModifiersCellDelegate {
    func decreaseQuantity(at index: Int, with count: Int) {
        viewModel.changeModifierCount(at: index, with: count)
        viewModel.decreaseTotalCount()
    }

    func increaseQuantity(at index: Int, with count: Int) {
        viewModel.changeModifierCount(at: index, with: count)
        viewModel.increaseTotalCount()
    }
}

extension ModifiersController {
    struct Output {
        let close = PublishRelay<Void>()
    }
}
