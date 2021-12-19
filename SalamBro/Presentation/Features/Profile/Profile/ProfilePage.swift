//
//  ProfilePage.swift
//  SalamBro
//
//  Created by Arystan on 3/18/21.
//

import RxCocoa
import RxSwift
import UIKit

final class ProfilePage: UIViewController, LoaderDisplayable {
    let outputs = Output()

    private let disposeBag = DisposeBag()

    private let viewModel: ProfileViewModel
    private let contentView = ProfileView()

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        bindViews()
        bindViewModel()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        reloadPage()

        navigationItem.title = SBLocalization.localized(key: ProfileText.Profile.title)
    }

    func reloadPage() {
        guard viewModel.userDidAuthenticate() else {
            showEmptyState()
            return
        }

        viewModel.fetchUserInfo()
    }

    private func bindViews() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self

        contentView.changeNameButton.rx.tap
            .bind { [weak self] in
                guard let userInfo = self?.viewModel.currentUserInfo else { return }
                self?.outputs.onChangeUserInfo.accept(userInfo)
            }
            .disposed(by: disposeBag)

        contentView.logoutButton.rx.tap
            .bind { [weak self] in
                self?.handleLogoutAction()
            }
            .disposed(by: disposeBag)
    }

    private func handleLogoutAction() {
        let yesAction = UIAlertAction(title: SBLocalization.localized(key: ProfileText.Profile.Alert.Action.yes),
                                      style: .default) { [weak self] _ in
            self?.viewModel.logout()
        }

        let noAction = UIAlertAction(title: SBLocalization.localized(key: ProfileText.Profile.Alert.Action.no),
                                     style: .default, handler: nil)
        showAlert(title: SBLocalization.localized(key: ProfileText.Profile.Alert.title),
                  message: SBLocalization.localized(key: ProfileText.Profile.Alert.message),
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
                    self?.reloadPage()
                })
            })
            .disposed(by: disposeBag)

        viewModel.outputs.didGetUserInfo
            .subscribe(onNext: { [weak self] userInfo in
                self?.contentView.layoutUI()
                self?.updateViews(with: userInfo)
                self?.hideAnimationView(completionHandler: nil)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.didLogout
            .subscribe(onNext: { [weak self] in
                self?.showEmptyState()
            })
            .disposed(by: disposeBag)
    }

    private func updateViews(with model: UserInfoResponse) {
        if let phoneNumber = model.mobilePhone {
            contentView.phoneTitleLabel.text = phoneNumber.toPhoneNumber()
        }
        contentView.nameLabel.text = model.name
        contentView.emailLabel.text = model.email
    }

    private func showEmptyState() {
        showAnimationView(animationType: .profile) { [weak self] in
            self?.outputs.onLoginTapped.accept(())
        }
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

    func tableView(_: UITableView, shouldHighlightRowAt _: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .calmGray
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .arcticWhite
    }
}

extension ProfilePage: Reloadable {
    func reload() {
        reloadPage()
    }
}

extension ProfilePage {
    struct Output {
        let onChangeUserInfo = PublishRelay<UserInfoResponse>()
        let onTableItemPressed = PublishRelay<ProfileTableItem>()
        let onLoginTapped = PublishRelay<Void>()
    }
}
