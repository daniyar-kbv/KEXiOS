//
//  ChangeLanguageController.swift
//  SalamBro
//
//  Created by Arystan on 3/25/21.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class ChangeLanguageController: UIViewController {
    private let disposeBag = DisposeBag()

    private let viewModel: ChangeLanguageViewModel

    private lazy var languagesTableView: UITableView = {
        let table = UITableView()
        table.allowsMultipleSelection = false
        table.separatorColor = .mildBlue
        table.register(cellType: ChangeLanguageCell.self)
        table.tableFooterView = UIView()
        table.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        table.dataSource = self
        table.delegate = self
        table.addTableHeaderViewLine()
        table.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        return table
    }()

    let outputs = Output()

    init(viewModel: ChangeLanguageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = languagesTableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .arcticWhite
        navigationItem.title = SBLocalization.localized(key: ProfileText.ChangeLanguage.title)
        bindViewModel()
    }
}

extension ChangeLanguageController {
    private func bindViewModel() {
        viewModel.outputs.didChangeLanguage
            .subscribe(onNext: { [weak self] in
                self?.languagesTableView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.didEnd
            .bind(to: outputs.restart)
            .disposed(by: disposeBag)
    }
}

extension ChangeLanguageController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        50
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.languages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ChangeLanguageCell.self)
        let languageInfo = viewModel.getLanguage(at: indexPath.row)
        cell.configure(with: languageInfo.language, isCurrent: languageInfo.isCurrent)
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.changeLanguage(at: indexPath.row)
    }
}

extension ChangeLanguageController {
    struct Output {
        let restart = PublishRelay<Void>()
    }
}
