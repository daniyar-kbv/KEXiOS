//
//  GetNameController.swift
//  SalamBro
//
//  Created by Arystan on 3/10/21.
//

import RxCocoa
import RxSwift
import UIKit

final class SetNameController: UIViewController, AlertDisplayable, LoaderDisplayable {
    private let disposeBag = DisposeBag()

    var didGetEnteredName: ((String) -> Void)?

    private lazy var rootView = SetNameView(delegate: self)
    private let viewModel: SetNameViewModel

    init(viewModel: SetNameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
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

    private func bindViewModel() {
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

        viewModel.outputs.didSaveUserName
            .bind { [weak self] userInfo in
                guard let name = userInfo.name else { return }
                self?.didGetEnteredName?(name)
            }
            .disposed(by: disposeBag)
    }

    @objc private func dismissVC() {
        navigationController?.popViewController(animated: true)
    }
}

extension SetNameController: GetNameViewDelegate {
    func submit(name: String) {
        viewModel.persist(name: name)
    }
}
