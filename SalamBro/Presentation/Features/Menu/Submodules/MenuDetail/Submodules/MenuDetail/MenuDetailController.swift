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

    private lazy var contentView = MenuDetailView(delegate: self)

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

        view = contentView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        bindViewModel()
        viewModel.update()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        contentView.updateTableViewHeight()
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

        contentView.modifiersTableView.delegate = self
        contentView.modifiersTableView.dataSource = self
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

        viewModel.outputs.itemImage
            .subscribe(onNext: { [weak self] url in
                guard let url = url else { return }
                self?.contentView.setImage(url: url)
            }).disposed(by: disposeBag)

        viewModel.outputs.updateModifiers
            .bind(to: contentView.modifiersTableView.rx.reload)
            .disposed(by: disposeBag)

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
            .bind(to: outputs.close)
            .disposed(by: disposeBag)

        viewModel.outputs.isComplete
            .subscribe(onNext: { [weak self] isComplete in
                self?.contentView.setProceedButton(isActive: isComplete)
            }).disposed(by: disposeBag)

        viewModel.outputs.didSelectModifier
            .subscribe(onNext: { [weak self] modifier, indexPath in
                self?.updateCell(with: modifier, at: indexPath)
            }).disposed(by: disposeBag)
    }

    private func layoutUI() {
        view.backgroundColor = .white
        tabBarController?.tabBar.backgroundColor = .white
    }

    private func updateCell(with modifier: Modifier, at indexPath: IndexPath) {
        let cell = contentView.modifiersTableView.cellForRow(at: indexPath) as! MenuDetailModifierCell
        cell.set(value: modifier)
    }

    func set(modifier: Modifier, at indexPath: IndexPath) {
        viewModel.set(modifier: modifier, at: indexPath)
    }
}

extension MenuDetailController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return viewModel.modifierGroups.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.modifierGroups[section].maxAmount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MenuDetailModifierCell.self), for: indexPath) as! MenuDetailModifierCell
        cell.configure(modifierGroup: viewModel.modifierGroups[indexPath.section])
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        outputs.toModifiers.accept((viewModel.modifierGroups[indexPath.section], indexPath))
    }
}

extension MenuDetailController: MenuDetailViewDelegate {
    func commentaryViewTapped() {
        commentaryPage = MapCommentaryPage()
        commentaryPage?.configureTextField(placeholder: L10n.MenuDetail.commentaryField)

        commentaryPage?.output.didProceed.subscribe(onNext: { [weak self] comment in
            guard let comment = comment else { return }
            self?.contentView.configureTextField(text: comment)
            self?.viewModel.set(comment: comment)
        }).disposed(by: disposeBag)

        commentaryPage?.output.didTerminate.subscribe(onNext: { [weak self] in
            self?.commentaryPage = nil
        }).disposed(by: disposeBag)

        commentaryPage?.openTransitionSheet(on: self)
    }

    func proceedButtonTapped() {
        viewModel.proceed()
    }
}

extension MenuDetailController {
    struct Output {
        let didTerminate = PublishRelay<Void>()
        let close = PublishRelay<Void>()
        let toModifiers = PublishRelay<(ModifierGroup, IndexPath)>()
    }
}
