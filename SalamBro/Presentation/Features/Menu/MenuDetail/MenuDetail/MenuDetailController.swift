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

final class MenuDetailController: UIViewController, LoaderDisplayable {
    private var viewModel: MenuDetailViewModel

    private let disposeBag = DisposeBag()
    let outputs = Output()

    private lazy var contentView = MenuDetailView(delegate: self)

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

        view = contentView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        bindViewModel()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        contentView.updateTableViewHeight()
        view.layoutIfNeeded()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.update()
    }
}

extension MenuDetailController {
    private func configureViews() {
        view.backgroundColor = .white
        tabBarController?.tabBar.backgroundColor = .white

        contentView.modifiersTableView.delegate = self
        contentView.modifiersTableView.dataSource = self

        contentView.setCommentary { [weak self] in
            self?.commentaryViewTapped()
        }

        setBackButton { [weak self] in
            self?.outputs.close.accept(())
        }
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
                self?.outputs.close.accept(())
                guard let error = error else { return }
                self?.showError(error)
            }).disposed(by: disposeBag)

        viewModel.outputs.didGetBranchClosed
            .subscribe(onNext: { [weak self] error in
                self?.showError(
                    error, completion: {
                        self?.outputs.close.accept(())
                    }
                )
            }).disposed(by: disposeBag)

        viewModel.outputs.itemImage
            .subscribe(onNext: { [weak self] url in
                guard let url = url else { return }
                self?.contentView.setImageView(with: url)
            }).disposed(by: disposeBag)

        viewModel.outputs.updateModifiers
            .subscribe(onNext: { [weak self] in
                self?.contentView.modifiersTableView.reloadData()
                self?.contentView.updateTableViewHeight()
            }).disposed(by: disposeBag)

        viewModel.outputs.itemTitle
            .bind(to: contentView.itemTitleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.itemDescription
            .bind(to: contentView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.itemPrice
            .bind(to: contentView.proceedButton.rx.title())
            .disposed(by: disposeBag)

        viewModel.outputs.didProceed
            .subscribe(onNext: { [weak self] in
                self?.outputs.close.accept(())
                self?.showAddedView()
            }).disposed(by: disposeBag)

        viewModel.outputs.isComplete
            .subscribe(onNext: { [weak self] isComplete in
                self?.contentView.setProceedButton(isActive: isComplete)
            }).disposed(by: disposeBag)

        viewModel.outputs.didGetProductDetail
            .subscribe(onNext: { [weak self] in
                self?.contentView.configureContentView(with: false)
            }).disposed(by: disposeBag)
    }

    private func layoutUI() {
        view.backgroundColor = .white
        tabBarController?.tabBar.backgroundColor = .white
    }

    private func showAddedView() {
        let addedView = AddedView()

        let window = UIApplication.shared.keyWindow!
        window.addSubview(addedView)

        addedView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(75)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }

        UIView.animate(
            withDuration: 0.2,
            delay: 2,
            options: .curveEaseInOut,
            animations: {
                addedView.alpha = 0
            },
            completion: { completed in
                guard completed else { return }
                addedView.removeFromSuperview()
            }
        )
    }
}

extension MenuDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.modifierCellViewModels.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return MenuDetailModifierCell(viewModel: viewModel.modifierCellViewModels[indexPath.row], delegate: self,
                                      index: indexPath.row)
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        outputs.toModifiers.accept(viewModel.modifierCellViewModels[indexPath.row].getModifierGroup())
    }
}

extension MenuDetailController: MenuDetailModifierCellDelegate {
    func changeButtonTapped(at index: Int) {
        outputs.toModifiers.accept(viewModel.modifierCellViewModels[index].getModifierGroup())
    }
}

extension MenuDetailController: MenuDetailViewDelegate {
    func commentaryViewTapped() {
        let commentaryPage = MapCommentaryPage()

        commentaryPage.configureTextField(placeholder: SBLocalization.localized(key: MenuText.MenuDetail.commentPlaceholder))

        commentaryPage.output.didProceed.subscribe(onNext: { [weak self] comment in
            guard let comment = comment else { return }
            self?.contentView.configureTextField(text: comment)
            self?.viewModel.set(comment: comment)
        }).disposed(by: disposeBag)

        commentaryPage.openTransitionSheet(on: self, with: viewModel.getComment())
    }

    func proceedButtonTapped() {
        viewModel.proceed()
    }
}

extension MenuDetailController: Reloadable {
    func reload() {
        viewModel.update()
    }
}

extension MenuDetailController {
    struct Output {
        let didTerminate = PublishRelay<Void>()
        let close = PublishRelay<Void>()
        let toModifiers = PublishRelay<ModifierGroup>()
    }
}
