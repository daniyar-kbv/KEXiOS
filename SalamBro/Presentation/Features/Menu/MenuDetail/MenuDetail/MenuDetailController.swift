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
    private var viewDidAppear = false

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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateHeight()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !viewDidAppear {
            viewModel.update()
        } else {
            viewDidAppear = true
        }
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
                self?.contentView.setImageView(with: url)
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

    private func updateHeight() {
        contentView.update(tableViewHeight: viewModel.getTotalHeight())
        contentView.modifiersTableView.reloadData()
    }
}

extension MenuDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.modifierCellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MenuDetailModifierCell.self), for: indexPath) as! MenuDetailModifierCell
        cell.set(viewModel: viewModel.modifierCellViewModels[indexPath.row],
                 modifiersViewModel: viewModel.modifiersViewModels[indexPath.row],
                 viewController: self,
                 index: indexPath.row)
        return cell
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getCellHeight(at: indexPath.row)
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
    }
}
