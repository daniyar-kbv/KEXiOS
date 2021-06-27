//
//  RateController.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/16/21.
//

import Cosmos
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class RateController: UIViewController {
    private let viewModel: RateViewModel
    private let disposeBag = DisposeBag()

    private var rateView: RateView?

    private var commentaryPage: MapCommentaryPage?

    init(viewModel: RateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        rateView = RateView(delegate: self)
        view = rateView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rateView?.setCollectionViewHeight()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.shadowImage = .init()
        navigationController?.navigationBar.setBackgroundImage(.init(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .kexRed
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor: UIColor.black,
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "chevron.left"), style: .plain, target: self, action: #selector(dismissVC))
        navigationItem.title = L10n.RateOrder.title
    }
}

extension RateController {
    private func configureViews() {
        view.backgroundColor = .arcticWhite

        rateView?.collectionView.delegate = self
        rateView?.collectionView.dataSource = self
    }
}

extension RateController {
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}

extension RateController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RateItemCell = collectionView.dequeueReusableCell(for: indexPath, cellType: RateItemCell.self)
        cell.configureTitleLabel(with: viewModel.data[indexPath.row])
        if viewModel.selectedItems.firstIndex(of: viewModel.data[indexPath.row]) != nil {
            cell.setSelectedUI()
        } else {
            cell.setDeselectedUI()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? RateItemCell
        if let index = viewModel.selectedItems.firstIndex(of: viewModel.data[indexPath.row]) {
            viewModel.deleteSelectedChoice(at: index)
            cell?.setDeselectedUI()
        } else {
            cell?.setSelectedUI()
            viewModel.condigureSelectedChoices(with: viewModel.data[indexPath.row])
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RateItemCell
        if let index = viewModel.selectedItems.firstIndex(of: viewModel.data[indexPath.row]) {
            viewModel.deleteSelectedChoice(at: index)
        }
        cell.setDeselectedUI()
    }
}

extension RateController: RateViewDelegate {
    func commentaryViewTapped() {
        commentaryPage = MapCommentaryPage()
        commentaryPage?.configureTextField(placeholder: L10n.RateOrder.CommentaryField.placeholder)

        commentaryPage?.output.didProceed.subscribe(onNext: { comment in
            if let comment = comment {
                self.rateView?.configureTextField(with: comment)
            }
        }).disposed(by: disposeBag)
        commentaryPage?.output.didTerminate.subscribe(onNext: { [weak self] in
            self?.commentaryPage = nil
        }).disposed(by: disposeBag)

        commentaryPage?.openTransitionSheet(on: self)
    }

    func sendButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    func updateViewModelData(at rating: Int) {
        switch rating {
        case 3:
            viewModel.changeDataSet(with: viewModel.arrayStar13)
        case 4:
            viewModel.changeDataSet(with: viewModel.arrayStar4)
        case 5:
            viewModel.changeDataSet(with: viewModel.arrayStar5)
        default:
            viewModel.changeDataSet(with: viewModel.arrayStar13)
        }
    }
}
