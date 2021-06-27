//
//  SuggestViewController.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/16/21.
//

import CoreLocation
import SnapKit
import UIKit
import YandexMapKitSearch

protocol SuggestControllerDelegate: AnyObject {
    func reverseGeocoding(searchQuery: String, title: String)
}

final class SuggestController: UIViewController {
    private var contentView: SuggestView?

    private lazy var tableView = UITableView()

    private let locationManager = CLLocationManager()
    private let searchManager = YMKSearch.sharedInstance().createSearchManager(with: .online)

    private var suggestSession: YMKSearchSuggestSession!
    private var suggestResults: [YMKSuggestItem] = []
    private var targetLocation = YMKPoint()

    private var fullQuery: String = ""

    weak var suggestDelegate: SuggestControllerDelegate?

    override func loadView() {
        super.loadView()
        contentView = SuggestView(delegate: self)
    }

    init() {
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
        suggestSession = searchManager.createSuggestSession()
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

        contentView?.clipsToBounds = true
        contentView?.layer.cornerRadius = 10
        contentView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }

    private func layoutUI() {
        guard let contentView = contentView else { return }
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
    private func onSuggestResponse(_ items: [YMKSuggestItem]) {
        suggestResults = items
        tableView.reloadData()
    }

    private func onSuggestError(_ error: Error) {
        let suggestError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
        var errorMessage = "Unknown error"
        if suggestError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Network error"
        } else if suggestError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Remote server error"
        }

        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}

extension SuggestController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SuggestCell.self)
        // add viewModel configuration
        cell.configureUI(address: suggestResults[indexPath.row].title.text, subtitle: suggestResults[indexPath.row].subtitle!.text)
        return cell
    }

    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return suggestResults.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? SuggestCell
        guard let address = cell?.addressLabel.text, let title = contentView?.searchBar.text else { return }
        contentView?.setSearchBarText(with: address)

        if let subtitle = cell?.subtitleLabel.text {
            fullQuery = subtitle + address
        } else {
            fullQuery = address
        }
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true, completion: nil)

        suggestDelegate?.reverseGeocoding(searchQuery: fullQuery, title: title)
    }
}

extension SuggestController: SuggestViewDelegate {
    func searchBarTapped(_ textField: UITextField) {
        let suggestHandler = { (response: [YMKSuggestItem]?, error: Error?) -> Void in
            if let items = response {
                self.onSuggestResponse(items)
            } else {
                self.onSuggestError(error!)
            }
        }
        let point = YMKPoint(latitude: ALA_LAT, longitude: ALA_LON)
        suggestSession.suggest(
            withText: textField.text!,
            window: YMKBoundingBox(southWest: point, northEast: point),
            suggestOptions: YMKSuggestOptions(suggestTypes: .geo, userPosition: point, suggestWords: true),
            responseHandler: suggestHandler
        )
    }

    func doneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
