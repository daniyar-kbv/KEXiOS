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

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ModifiersCell.self, forCellWithReuseIdentifier: String(describing: ModifiersCell.self))
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .arcticWhite
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 23, bottom: 20, right: 23)
        return collectionView
    }()

    override func loadView() {
        super.loadView()

        view = collectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setBackButton { [weak self] in
            self?.outputs.close.accept(())
        }

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
}

extension ModifiersController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        outputs.didSelectModifier.accept(viewModel.modifiers[indexPath.item])
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.modifiers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ModifiersCell.self), for: indexPath) as! ModifiersCell
        cell.configure(modifier: viewModel.modifiers[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let freeWidth = collectionView.frame.size.width - 54
        let cellWidth = freeWidth / 2
        let cellHeight = cellWidth * (195 / 160)
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 16
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 8
    }
}

extension ModifiersController {
    struct Output {
        let close = PublishRelay<Void>()
        let didSelectModifier = PublishRelay<Modifier>()
    }
}
