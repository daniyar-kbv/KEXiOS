//
//  SuggestViewController.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/16/21.
//

import RxCocoa
import RxSwift
import UIKit

protocol SuggestControllerDelegate: AnyObject {
    func reverseGeocoding(searchQuery: String, title: String)
}

final class SuggestController: UIViewController {
    private let disposeBag = DisposeBag()

    private let viewModel: SuggestViewModel

    private lazy var contentView = SuggestView(delegate: self)

    private lazy var tableView = UITableView()

    weak var suggestDelegate: SuggestControllerDelegate?

    init(viewModel: SuggestViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        layoutUI()
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        contentView.searchBar.becomeFirstResponder()
    }
}

extension SuggestController {
    private func configureViews() {
        view.backgroundColor = .arcticWhite

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .arcticWhite
        tableView.register(cellType: SuggestCell.self)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        tableView.delaysContentTouches = false

        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }

    private func layoutUI() {
        [contentView, tableView].forEach {
            view.addSubview($0)
        }

        contentView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
    }
}

extension SuggestController {
    private func bindViewModel() {
        viewModel.outputs.didEndRequest
            .subscribe(onNext: { [weak self] in
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)

        viewModel.outputs.didFail
            .subscribe(onNext: { [weak self] error in
                self?.showError(error)
            }).disposed(by: disposeBag)
    }
}

extension SuggestController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SuggestCell.self)
        cell.configure(with: viewModel.getResultAddress(at: indexPath.row))
        return cell
    }

    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.suggestResults.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? SuggestCell
        guard let address = cell?.addressLabel.text, let title = contentView.searchBar.text else { return }
        contentView.setSearchBarText(with: address)

        if let subtitle = cell?.subtitleLabel.text {
            viewModel.setQuery(with: subtitle + address)
        } else {
            viewModel.setQuery(with: address)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true, completion: nil)

        suggestDelegate?.reverseGeocoding(searchQuery: viewModel.fullQuery, title: title)
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

extension SuggestController: SuggestViewDelegate {
    func searchBarTapped(_ textField: UITextField) {
        guard let query = textField.text else { return }
        viewModel.search(with: query)
    }

    func doneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
