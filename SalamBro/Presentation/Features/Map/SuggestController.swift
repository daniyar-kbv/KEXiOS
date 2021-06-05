//
//  SuggestViewController.swift
//  yandex-map
//
//  Created by Arystan on 4/6/21.
//

import CoreLocation
import UIKit
import YandexMapKitSearch

protocol SuggestControllerDelegate: AnyObject {
    func reverseGeocoding(searchQuery: String, title: String)
}

class SuggestController: ViewController {
    @IBOutlet var contentView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UITextField!
    @IBOutlet var cancelButton: UIButton!

    let locationManager = CLLocationManager()
    let searchManager = YMKSearch.sharedInstance().createSearchManager(with: .online)

    var suggestSession: YMKSearchSuggestSession!
    var suggestResults: [YMKSuggestItem] = []
    var targetLocation = YMKPoint()

    var fullQuery: String = ""

    weak var delegate: MapDelegate? // MARK: Legacy

    weak var suggestDelegate: SuggestControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        suggestSession = searchManager.createSuggestSession()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SuggestCell", bundle: nil), forCellReuseIdentifier: "SuggestCell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // legacy
        delegate?.mapShadow(toggle: true)
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func setupViews() {
        searchBar.attributedPlaceholder = NSAttributedString(
            string: L10n.Suggest.AddressField.title,
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        cancelButton.setTitle(L10n.Suggest.Button.title, for: .normal)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
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

    @IBAction func queryChange(_ sender: UITextField) {
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

    @IBAction func cancelAction(_: UIButton) {
        dismiss(animated: true, completion: nil)

        // MARK: Tech debt, legacy

        delegate?.mapShadow(toggle: false)
    }
}

extension SuggestController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt path: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestCell", for: path) as! SuggestCell
        cell.addressTitle.text = suggestResults[path.row].title.text
        cell.subtitleTitle.text = suggestResults[path.row].subtitle?.text
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
        searchBar.text = cell.addressTitle.text
        if let subtitle = cell.subtitleTitle.text {
            fullQuery = subtitle + cell.addressTitle.text!
        } else {
            fullQuery = cell.addressTitle.text!
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
