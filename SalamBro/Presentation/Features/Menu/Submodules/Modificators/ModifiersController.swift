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
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: .init()
        )
        collectionView.register(ModifiersCell.self, forCellWithReuseIdentifier: String(describing: ModifiersCell.self))
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.collectionViewLayout = StagLayout(widthHeightRatios: [(0.49, 0.6)], itemSpacing: 8)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        return collectionView
    }()

    override func loadView() {
        super.loadView()
        view = collectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .arcticWhite
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setBackButton { [weak self] in
            self?.outputs.close.accept(())
        }
    }
}

extension ModifiersController {
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}

extension ModifiersController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, didSelectItemAt _: IndexPath) {
        dismiss(animated: true, completion: nil)
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ModifiersCell.self), for: indexPath) as! ModifiersCell
        return cell
    }
}

extension ModifiersController {
    struct Output {
        let close = PublishRelay<Void>()
    }
}
