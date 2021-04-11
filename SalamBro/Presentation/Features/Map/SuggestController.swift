//
//  SuggestViewController.swift
//  yandex-map
//
//  Created by Arystan on 4/6/21.
//

import UIKit
import YandexMapKitSearch
import CoreLocation

class SuggestController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    
    let locationManager = CLLocationManager()
    let searchManager = YMKSearch.sharedInstance().createSearchManager(with: .online)
    
    var suggestSession: YMKSearchSuggestSession!
    var suggestResults: [YMKSuggestItem] = []
    var targetLocation = YMKPoint()
    var BOUNDING_BOX = YMKBoundingBox(
        southWest: YMKPoint(latitude: 43.222015, longitude: 76.851250),
        northEast: YMKPoint(latitude: 43.222015, longitude: 76.851250))
    var fullQuery: String = ""
    var delegate: MapDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        suggestSession = searchManager.createSuggestSession()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SuggestCell", bundle: nil), forCellReuseIdentifier: "SuggestCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.mapShadow(toggle: true)
//        prepareBackgroundView()
    }
    
    func setupViews() {
        contenView.clipsToBounds = true
        contenView.layer.cornerRadius = 10
        contenView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
//        prepareBackgroundView()
    }
    
    func prepareBackgroundView(){
//        let backgroundView = UIView()
//        backgroundView.frame = UIScreen.main.bounds
//        backgroundView.backgroundColor = UIColor.darkGray
//        backgroundView.alpha = 0.3
//
//        view.insertSubview(backgroundView, at: 0)
        
//        let blurEffect = UIBlurEffect.init(style: .dark)
//        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
//        let bluredView = UIVisualEffectView.init(effect: blurEffect)
//        bluredView.contentView.addSubview(visualEffect)
//        visualEffect.frame = UIScreen.main.bounds
//        bluredView.frame = UIScreen.main.bounds
//
//        view.insertSubview(bluredView, at: 0)
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
        let suggestHandler = {(response: [YMKSuggestItem]?, error: Error?) -> Void in
            if let items = response {
                self.onSuggestResponse(items)
            } else {
                self.onSuggestError(error!)
            }
        }
        let locValue: CLLocationCoordinate2D = locationManager.location!.coordinate
        let point = YMKPoint(latitude: locValue.latitude, longitude: locValue.longitude)
        suggestSession.suggest(
            withText: sender.text!,
            window: BOUNDING_BOX,
            suggestOptions: YMKSuggestOptions(suggestTypes: .geo, userPosition: point, suggestWords: true),
            responseHandler: suggestHandler
        )
    }
    
    @IBAction func selectAddressAction(_ sender: UIButton) {
        if searchBar.text != nil {
            self.dismiss(animated: true) {
                self.delegate?.passData(searchQuery: self.fullQuery, title: self.searchBar.text!)
                self.delegate?.mapShadow(toggle: false)
                print("exit select adreess view")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt path: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestCell", for: path) as! SuggestCell
        cell.addressTitle.text = suggestResults[path.row].title.text
        cell.subtitleTitle.text = suggestResults[path.row].subtitle?.text
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    }
}
