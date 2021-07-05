//
//  ProfilePage.swift
//  SalamBro
//
//  Created by Arystan on 3/18/21.
//

import RxCocoa
import RxSwift
import UIKit

final class ProfilePage: UIViewController, AlertDisplayable, LoaderDisplayable, AnimationViewPresentable {
    let outputs = Output()

    private let disposeBag = DisposeBag()

    private lazy var phoneTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .mildBlue
        return label
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = DefaultStorageImpl.sharedStorage.userName ?? ""
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.textAlignment = .left
        return label
    }()

    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()

    private lazy var changeNameButton: UIButton = {
        let label = UIButton()
        label.setTitle(L10n.Profile.EditButton.title, for: .normal)
        label.setTitleColor(.kexRed, for: .normal)
        label.titleLabel?.font = .systemFont(ofSize: 12)
        label.isUserInteractionEnabled = true
        return label
    }()

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorColor = .mildBlue
        table.addTableHeaderViewLine()
        table.tableFooterView = UIView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.showsVerticalScrollIndicator = false
        table.isScrollEnabled = false
        table.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        table.rowHeight = 50
        return table
    }()

    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Profile.LogoutButton.title, for: .normal)
        button.setTitleColor(.mildBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.borderWidth = 1
        button.borderColor = .mildBlue
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()

    private let viewModel: ProfileViewModel

    private var needsLayoutUI = true

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViews()
        bindViewModel()

        reloadPage()
    }

    func reloadPage() {
        guard viewModel.userDidAuthenticate() else {
            showEmptyState()
            return
        }

        viewModel.fetchUserInfo()
    }

    func set(userInfo: UserInfoResponse) {
        viewModel.set(userInfo: userInfo)
    }

    private func bindViews() {
        tableView.delegate = self
        tableView.dataSource = self

        changeNameButton.rx.tap
            .bind { [weak self] in
                guard let userInfo = self?.viewModel.currentUserInfo else { return }
                self?.outputs.onChangeUserInfo.accept(userInfo)
            }
            .disposed(by: disposeBag)

        logoutButton.rx.tap
            .bind { [weak self] in
                self?.handleLogoutAction()
            }
            .disposed(by: disposeBag)
    }

    private func handleLogoutAction() {
        let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            self?.viewModel.logout()
            self?.showEmptyState()
        }

        let noAction = UIAlertAction(title: "Нет", style: .default, handler: nil)

        showAlert(title: "Вы уверены?",
                  message: "Вы уверены что хотите выйти из аккаунта?",
                  actions: [yesAction, noAction])
    }

    private func bindViewModel() {
        viewModel.outputs.didStartRequest
            .subscribe(onNext: { [weak self] in
                self?.showLoader()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.didEndRequest
            .subscribe(onNext: { [weak self] in
                self?.hideLoader()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.didFail
            .subscribe(onNext: { [weak self] error in
                self?.showError(error, completion: {
                    self?.showEmptyState()
                })
            })
            .disposed(by: disposeBag)

        viewModel.outputs.didGetUserInfo
            .subscribe(onNext: { [weak self] userInfo in
                self?.layoutUI()
                self?.updateViews(with: userInfo)
                self?.hideAnimationView()
            })
            .disposed(by: disposeBag)
    }

    private func updateViews(with model: UserInfoResponse) {
        if let phoneNumber = model.mobilePhone {
            phoneTitleLabel.text = phoneNumber
        }
        nameLabel.text = model.name
        emailLabel.text = model.email
    }

    private func showEmptyState() {
        showAnimationView(delegate: self, animationType: .profile)
    }

    private func layoutUI() {
        guard needsLayoutUI else { return }
        needsLayoutUI = false

        navigationItem.title = L10n.Profile.NavigationBar.title
        view.backgroundColor = .arcticWhite

        view.addSubview(phoneTitleLabel)
        phoneTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(21)
        }

        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(phoneTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.lessThanOrEqualToSuperview().offset(-24)
        }

        view.addSubview(changeNameButton)
        changeNameButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(16)
            $0.width.lessThanOrEqualTo(64)
            $0.centerY.equalTo(nameLabel)
        }

        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(14)
        }

        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(43)
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(19)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(logoutButton.snp.top).offset(-8)
        }
    }
}

extension ProfilePage: AnimationContainerViewDelegate {
    func performAction() {
        outputs.onLoginTapped.accept(())
    }
}

extension ProfilePage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.tableItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cell.tintColor = .kexRed
        cell.selectionStyle = .none
        cell.imageView?.image = viewModel.tableItems[indexPath.row].icon
        cell.textLabel?.text = viewModel.tableItems[indexPath.row].title
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.tableItems[indexPath.row]
        outputs.onTableItemPressed.accept(item)
    }
}

extension ProfilePage {
    struct Output {
        let onChangeUserInfo = PublishRelay<UserInfoResponse>()
        let onTableItemPressed = PublishRelay<ProfileTableItem>()
        let onLoginTapped = PublishRelay<Void>()
    }
}
