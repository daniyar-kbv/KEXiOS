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
        collectionView.register(cellType: ModifiersCell.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .arcticWhite
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 23, bottom: 20, right: 23)
        return collectionView
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .kexRed
        button.cornerRadius = 10
        button.setTitle(SBLocalization.localized(key: CommentaryText.buttonTitle), for: .normal)
        button.setTitleColor(.arcticWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        button.layer.masksToBounds = true
        return button
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

        viewModel.outputs.showDoneButton
            .bind { [weak self] _ in
                self?.addDoneButton()
            }
            .disposed(by: disposeBag)

        viewModel.outputs.hideDoneButton
            .bind { [weak self] _ in
                self?.doneButton.removeFromSuperview()
            }
            .disposed(by: disposeBag)
    }

    private func addDoneButton() {
        view.addSubview(doneButton)

        doneButton.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            $0.height.equalTo(43)
        }
    }

    @objc private func doneButtonPressed() {
        let selectedChoices = viewModel.modifiers.filter { $0.itemCount > 0 }
        viewModel.setSelectedModifiers(with: selectedChoices)
        outputs.close.accept(())
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
