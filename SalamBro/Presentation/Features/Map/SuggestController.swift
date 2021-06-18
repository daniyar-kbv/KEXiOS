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
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var searchItem: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "search")
        imageView.tintColor = .mildBlue
        return imageView
    }()

    private lazy var searchBar: UITextField = {
        let searchBar = UITextField()
        searchBar.attributedPlaceholder = NSAttributedString(
            string: L10n.Suggest.AddressField.title,
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        searchBar.borderStyle = .none
        searchBar.clearButtonMode = .never
        searchBar.minimumFontSize = 17
        searchBar.adjustsFontSizeToFitWidth = true
        searchBar.contentHorizontalAlignment = .left
        searchBar.contentVerticalAlignment = .center
        searchBar.addTarget(self, action: #selector(queryChange(sender:)), for: .editingChanged)
        return searchBar
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Suggest.Button.title, for: .normal)
        button.setTitleColor(.kexRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.adjustsImageWhenHighlighted = true
        button.adjustsImageWhenDisabled = true
        button.addTarget(self, action: #selector(cancelAction(_:)), for: .allTouchEvents)
        return button
    }()

    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .mildBlue
        return view
    }()

    private lazy var tableView = UITableView()

    let locationManager = CLLocationManager()
    let searchManager = YMKSearch.sharedInstance().createSearchManager(with: .online)

    var suggestSession: YMKSearchSuggestSession!
    var suggestResults: [YMKSuggestItem] = []
    var targetLocation = YMKPoint()

    var fullQuery: String = ""

    weak var delegate: MapDelegate? // MARK: Legacy

    weak var suggestDelegate: SuggestControllerDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        layoutUI()
        suggestSession = searchManager.createSuggestSession()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // legacy
        delegate?.mapShadow(toggle: true)
    }

    func onSuggestResponse(_ items: [YMKSuggestItem]) {
        suggestResults = items
        tableView.reloadData()
    }

    func onSuggestError(_ error: Error) {
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

    @objc func queryChange(sender: UITextField) {
        let suggestHandler = { (response: [YMKSuggestItem]?, error: Error?) -> Void in
            if let items = response {
                self.onSuggestResponse(items)
            } else {
                self.onSuggestError(error!)
            }
        }
        let point = YMKPoint(latitude: ALA_LAT, longitude: ALA_LON)
        suggestSession.suggest(
            withText: sender.text!,
            window: YMKBoundingBox(southWest: point, northEast: point),
            suggestOptions: YMKSuggestOptions(suggestTypes: .geo, userPosition: point, suggestWords: true),
            responseHandler: suggestHandler
        )
    }

    @objc func cancelAction(_: UIButton) {
        dismiss(animated: true, completion: nil)

        // MARK: Tech debt, legacy

        delegate?.mapShadow(toggle: false)
    }
}

extension SuggestController {
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: SuggestCell.self)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
    }

    private func layoutUI() {
        view.backgroundColor = .arcticWhite

        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        [searchItem, searchBar, doneButton, separator, tableView].forEach {
            contentView.addSubview($0)
        }

        view.addSubview(contentView)

        searchItem.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalToSuperview().offset(24)
            $0.width.equalTo(24)
            $0.height.equalTo(28)
        }

        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(19)
            $0.left.equalTo(searchItem.snp.right).offset(8)
            $0.centerY.equalTo(searchItem.snp.centerY)
        }

        doneButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalTo(searchBar.snp.right).offset(8)
            $0.right.equalToSuperview().offset(-24)
            $0.centerY.equalTo(searchBar.snp.centerY)
        }

        separator.snp.makeConstraints {
            $0.top.equalTo(searchItem.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(0.3)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(separator.snp.bottom)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension SuggestController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SuggestCell.self)
        cell.addressLabel.text = suggestResults[indexPath.row].title.text
        cell.subtitleLabel.text = suggestResults[indexPath.row].subtitle?.text
        cell.selectionStyle = .none
        return cell
    }

    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return suggestResults.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SuggestCell
        searchBar.text = cell.addressLabel.text
        if let subtitle = cell.subtitleLabel.text {
            fullQuery = subtitle + cell.addressLabel.text!
        } else {
            fullQuery = cell.addressLabel.text!
        }
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true, completion: nil)

        guard let title = searchBar.text else { return }

        suggestDelegate?.reverseGeocoding(searchQuery: fullQuery, title: title)

        // MARK: Tech debt, legacy

        delegate?.reverseGeocoding(searchQuery: fullQuery, title: title)
        delegate?.mapShadow(toggle: false)
    }
}
