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

    private let contentView = MenuDetailView()

    private let dimmedView = UIView()

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

        layoutUI()
        configureViews()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
}

extension MenuDetailController {
    private func configureViews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(commetaryViewTapped(_:)))
        contentView.commentaryView.addGestureRecognizer(tap)

        contentView.chooseAdditionalItemButton.addTarget(self, action: #selector(additionalItemChangeButtonTapped), for: .touchUpInside)
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
                self?.contentView.imageView.setImage(url: url)
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

        viewModel.outputs.comment
            .bind(to: contentView.commentaryField.rx.text)
            .disposed(by: disposeBag)
    }

    private func layoutUI() {
        view.backgroundColor = .white
        tabBarController?.tabBar.backgroundColor = .white

        view.addSubview(dimmedView)

        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        dimmedView.backgroundColor = .gray
        dimmedView.alpha = 0
    }
}

extension MenuDetailController {
    @objc func additionalItemChangeButtonTapped() {
        outputs.toModifiers.accept(())
    }

    @objc func commetaryViewTapped(_: UITapGestureRecognizer? = nil) {
        commentaryPage = MapCommentaryPage()
        guard let page = commentaryPage else { return }
        page.cachedCommentary = contentView.commentaryField.text
        page.delegate = self
        page.configureTextField(placeholder: L10n.MenuDetail.commentaryField)
        present(page, animated: true, completion: nil)
        dimmedView.alpha = 0.5
    }

    @objc private func keyboardWillHide() {
        dimmedView.alpha = 0
    }

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

extension MenuDetailController: MapCommentaryPageDelegate {
    func onDoneButtonTapped(commentary: String) {
        viewModel.set(comment: commentary)
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
