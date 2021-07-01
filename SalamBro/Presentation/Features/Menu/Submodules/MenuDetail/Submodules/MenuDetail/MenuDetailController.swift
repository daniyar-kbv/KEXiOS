//
//  MenuDetailController.swift
//  SalamBro
//
//  Created by Arystan on 5/3/21.
//

import Reusable
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class MenuDetailController: UIViewController, AlertDisplayable, LoaderDisplayable {
    private var viewModel: MenuDetailViewModel

    private let disposeBag = DisposeBag()
    let outputs = Output()

    private var contentView: MenuDetailView?

    private var commentaryPage: MapCommentaryPage?

    public init(viewModel: MenuDetailViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { nil }

    deinit {
        outputs.didTerminate.accept(())
    }

    override func loadView() {
        super.loadView()
        contentView = MenuDetailView(delegate: self)
        view = contentView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        bindViewModel()
        viewModel.update()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setBackButton { [weak self] in
            self?.outputs.close.accept(())
        }
    }
}

extension MenuDetailController {
    private func configureViews() {
        view.backgroundColor = .white
        tabBarController?.tabBar.backgroundColor = .white
    }

    private func bindViewModel() {
        viewModel.outputs.didStartRequest
            .subscribe(onNext: { [weak self] in
                self?.showLoader()
            }).disposed(by: disposeBag)

        viewModel.outputs.didEndRequest
            .subscribe(onNext: { [weak self] in
                self?.hideLoader()
            }).disposed(by: disposeBag)

        viewModel.outputs.didGetError
            .subscribe(onNext: { [weak self] error in
                guard let error = error else { return }
                self?.showError(error)
            }).disposed(by: disposeBag)

        viewModel.outputs.close
            .bind(to: outputs.close)
            .disposed(by: disposeBag)

        viewModel.outputs.itemImage
            .subscribe(onNext: { [weak self] url in
                guard let url = url else { return }
                self?.contentView?.setImage(url: url)
            }).disposed(by: disposeBag)

        if let itemTitleLabel = contentView?.itemTitleLabel {
            viewModel.outputs.itemTitle
                .bind(to: itemTitleLabel.rx.text)
                .disposed(by: disposeBag)
        }

        if let itemDescriptionLabel = contentView?.descriptionLabel {
            viewModel.outputs.itemDescription
                .bind(to: itemDescriptionLabel.rx.text)
                .disposed(by: disposeBag)
        }

        if let itemPriceButton = contentView?.proceedButton {
            viewModel.outputs.itemPrice
                .bind(to: itemPriceButton.rx.title())
                .disposed(by: disposeBag)
        }
    }

    private func layoutUI() {
        view.backgroundColor = .white
        tabBarController?.tabBar.backgroundColor = .white
    }
}

extension MenuDetailController {
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func backButtonTapped() {
        outputs.close.accept(())
    }

    @objc private func proceedButtonTapped() {
        viewModel.proceed()
    }
}

extension MenuDetailController: MenuDetailViewDelegate {
    func commentaryViewTapped() {
        commentaryPage = MapCommentaryPage()
        commentaryPage?.configureTextField(placeholder: L10n.MenuDetail.commentaryField)

        commentaryPage?.output.didProceed.subscribe(onNext: { comment in
            if let comment = comment {
                self.contentView?.configureTextField(text: comment)
            }
        }).disposed(by: disposeBag)

        commentaryPage?.output.didTerminate.subscribe(onNext: { [weak self] in
            self?.commentaryPage = nil
        }).disposed(by: disposeBag)

        commentaryPage?.openTransitionSheet(on: self)
    }

    func changeButtonTapped() {
        outputs.toModifiers.accept(())
    }
}

extension MenuDetailController {
    struct Output {
        let didTerminate = PublishRelay<Void>()
        let close = PublishRelay<Void>()

//        Tech debt: finish when modifiers api resolved
        let toModifiers = PublishRelay<Void>()
    }
}
