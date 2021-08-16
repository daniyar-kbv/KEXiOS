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

final class RateController: UIViewController, LoaderDisplayable {
    private let viewModel: RateViewModel

    private let disposeBag = DisposeBag()

    private lazy var rateView = RateView(delegate: self)

    var outputs = Output()

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
        view = rateView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = SBLocalization.localized(key: ProfileText.RateOrder.title)
        configureViews()
        viewModel.getRateChoices()
        bindOutputs()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rateView.setCollectionViewHeight()
    }

    func setOrderNumber(with orderNumber: Int) {
        viewModel.setOrderNumber(with: orderNumber)
    }
}

extension RateController {
    private func configureViews() {
        view.backgroundColor = .arcticWhite

        rateView.collectionView.delegate = self
        rateView.collectionView.dataSource = self

        setBackButton { [weak self] in
            self?.outputs.close.accept(())
        }

        rateView.setCommentary { [weak self] in
            self?.commentaryViewTapped()
        }
    }

    private func bindOutputs() {
        viewModel.outputs.didStartRequest
            .bind { [weak self] in
                self?.showLoader()
            }
            .disposed(by: disposeBag)

        viewModel.outputs.didEndRequest
            .bind { [weak self] in
                self?.hideLoader()
            }
            .disposed(by: disposeBag)

        viewModel.outputs.didFail
            .bind { [weak self] error in
                self?.showError(error)
            }
            .disposed(by: disposeBag)

        viewModel.outputs.didGetQuestionTitle
            .bind { [weak self] title in
                self?.rateView.configureQuestionLabel(title: title)
            }
            .disposed(by: disposeBag)

        viewModel.outputs.didGetSuggestionTitle
            .bind { [weak self] description in
                self?.rateView.configureSuggestionLabel(description: description)
            }
            .disposed(by: disposeBag)
    }
}

extension RateController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.currentChoices.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: RateItemCell.self)
        cell.configure(with: viewModel.getRateItem(at: indexPath.row))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.configureDataSet(at: indexPath.row)
        collectionView.reloadData()
    }
}

extension RateController: RateViewDelegate {
    func commentaryViewTapped() {
        let commentaryPage = MapCommentaryPage()

        commentaryPage.configureTextField(placeholder: SBLocalization.localized(key: ProfileText.RateOrder.commentaryPlaceholder))

        commentaryPage.output.didProceed.subscribe(onNext: { comment in
            if let comment = comment {
                self.rateView.configureTextField(with: comment)
            }
        }).disposed(by: disposeBag)

        commentaryPage.openTransitionSheet(on: self)
    }

    func sendButtonTapped() {
        outputs.close.accept(())
        viewModel.sendUserRate(stars: rateView.rating, comment: rateView.getComment())
    }

    func updateViewModelData(at rating: Int) {
        viewModel.changeDataSet(by: rating)
    }
}

extension RateController {
    struct Output {
        let close = PublishRelay<Void>()
    }
}
