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

    private let rateView = RateView()

    private let dimmedView = UIView()

    private var commentaryPage: MapCommentaryPage?

    init(viewModel: RateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        layoutUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rateView.collectionViewHeightConstraint?.update(offset: rateView.collectionView.contentSize.height)
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
        rateView.collectionView.delegate = self
        rateView.collectionView.dataSource = self

        rateView.cosmosView.didFinishTouchingCosmos = didFinishTouchRating

        let tapCommentary = UITapGestureRecognizer(target: self, action: #selector(commentaryViewTapped))
        rateView.commentView.addGestureRecognizer(tapCommentary)

        rateView.sendButton.addTarget(self, action: #selector(dismissVC), for: .allTouchEvents)
    }

    private func layoutUI() {
        view.backgroundColor = .arcticWhite

        view.addSubview(rateView)
        rateView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        dimmedView.backgroundColor = .gray
        dimmedView.alpha = 0
    }

    private func didFinishTouchRating(_ rating: Double) {
        rateView.sendButton.isEnabled = true
        rateView.sendButton.backgroundColor = .kexRed
        switch rating {
        case 1.0 ..< 2.0:
            rateView.questionLabel.text = L10n.RateOrder.BadRate.title
            rateView.suggestionLabel.text = L10n.RateOrder.BadRate.subtitle
            viewModel.data = viewModel.arrayStar13
        case 2.0 ..< 3.0:
            rateView.questionLabel.text = L10n.RateOrder.BadRate.title
            rateView.suggestionLabel.text = L10n.RateOrder.BadRate.subtitle
            viewModel.data = viewModel.arrayStar13
        case 3.0 ..< 4.0:
            rateView.questionLabel.text = L10n.RateOrder.AverageRate.title
            rateView.suggestionLabel.text = L10n.RateOrder.AverageRate.title
            viewModel.data = viewModel.arrayStar13
        case 4.0 ..< 5.0:
            rateView.questionLabel.text = L10n.RateOrder.GoodRate.title
            rateView.suggestionLabel.text = L10n.RateOrder.GoodRate.subtitle
            viewModel.data = viewModel.arrayStar4
        case 5.0:
            rateView.questionLabel.text = L10n.RateOrder.ExcellentRate.title
            rateView.suggestionLabel.text = L10n.RateOrder.ExcellentRate.subtitle
            viewModel.data = viewModel.arrayStar5
        default:
            rateView.questionLabel.text = nil
            rateView.suggestionLabel.text = nil
        }
        rateView.collectionView.reloadData()
        rateView.collectionView.layoutIfNeeded()
    }
}

extension RateController {
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func commentaryViewTapped() {
        commentaryPage = MapCommentaryPage()
        guard let page = commentaryPage else { return }
        page.cachedCommentary = rateView.commentTextField.text
        page.delegate = self
        page.configureTextField(placeholder: L10n.RateOrder.CommentaryField.placeholder)
        present(page, animated: true, completion: nil)
        dimmedView.alpha = 0.5
    }

    @objc private func keyboardWillHide() {
        dimmedView.alpha = 0
    }
}

extension RateController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RateItemCell = collectionView.dequeueReusableCell(for: indexPath, cellType: RateItemCell.self)
        cell.titleLabel.text = viewModel.data[indexPath.row]
        if viewModel.selectedItems.firstIndex(of: viewModel.data[indexPath.row]) != nil {
            cell.setSelectedUI()
        } else {
            cell.setDeselectedUI()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RateItemCell
        if let index = viewModel.selectedItems.firstIndex(of: viewModel.data[indexPath.row]) {
            viewModel.selectedItems.remove(at: index)
            cell.setDeselectedUI()
        } else {
            cell.setSelectedUI()
            viewModel.selectedItems.append(viewModel.data[indexPath.row])
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RateItemCell
        if let index = viewModel.selectedItems.firstIndex(of: viewModel.data[indexPath.row]) {
            viewModel.selectedItems.remove(at: index)
        }
        cell.setDeselectedUI()
    }
}

extension RateController: MapCommentaryPageDelegate {
    func onDoneButtonTapped(commentary: String) {
        rateView.commentTextField.text = commentary
    }
}
