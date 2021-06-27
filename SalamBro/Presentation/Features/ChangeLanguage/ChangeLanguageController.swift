//
//  ChangeLanguageController.swift
//  SalamBro
//
//  Created by Arystan on 3/25/21.
//

import SnapKit
import UIKit

final class ChangeLanguageController: UIViewController {
    private let viewModel: ChangeLanguageViewModelImpl

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

    init(viewModel: ChangeLanguageViewModelImpl) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
    }
}

extension ChangeLanguageController {
    private func layoutUI() {
        view.backgroundColor = .arcticWhite
        view.addSubview(languagesTableView)

        languagesTableView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
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
        cell.configure(title: viewModel.getLanguage(at: indexPath), image: viewModel.getImage(at: indexPath))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ChangeLanguageCell {
            cell.didSelect()
        }
        navigationController?.popViewController(animated: true)
    }
}
