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
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.shadowImage = .init()
        navigationController?.navigationBar.setBackgroundImage(.init(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .kexRed
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "chevron.left"), style: .plain, target: self, action: #selector(dismissVC))
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        contentView?.updateTableViewHeight()
    }
}

extension MenuDetailController {
    private func configureViews() {
        view.backgroundColor = .white
        tabBarController?.tabBar.backgroundColor = .white

        contentView?.modifiersTableView.delegate = self
        contentView?.modifiersTableView.dataSource = self
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
            .subscribe(onNext: { [weak self] in
                self?.outputs.close.accept(())
            }).disposed(by: disposeBag)

        viewModel.outputs.itemImage
            .subscribe(onNext: { [weak self] url in
                guard let url = url else { return }
                self?.contentView?.setImage(url: url)
            }).disposed(by: disposeBag)

        viewModel.outputs.updateModifiers
            .subscribe(onNext: { [weak self] in
                self?.contentView?.modifiersTableView.reloadData()
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

    func set(modifier: Modifier, at indexPath: IndexPath) {
        let cell = contentView?.modifiersTableView.cellForRow(at: indexPath) as! MenuDetailModifierCell
        cell.set(value: modifier)
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

    func tableView(_: UITableView, didDeselectRowAt indexPath: IndexPath) {
        outputs.toModifiers.accept((viewModel.modifierGroups[indexPath.section], indexPath))
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
}

extension MenuDetailController {
    struct Output {
        let didTerminate = PublishRelay<Void>()
        let close = PublishRelay<Void>()

        let toModifiers = PublishRelay<(ModifierGroup, IndexPath)>()
    }
}
