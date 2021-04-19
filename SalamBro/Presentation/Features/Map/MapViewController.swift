//
//  ViewController.swift
//  yandex-map
//
//  Created by Arystan on 3/31/21.
//

import UIKit
import YandexMapKit
import CoreLocation
import YandexMapKitSearch

class MapViewController: UIViewController {
    
    var targetLocation = YMKPoint(latitude: ALA_LAT, longitude: ALA_LON)
    let locationManager = CLLocationManager()
    let searchManager = YMKSearch.sharedInstance().createSearchManager(with: .online)
    var searchSession: YMKSearchSession?
    
    var mapView: YMKMapView = {
        let view = YMKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//FIXME: - first execution bool
//    var isItFirstSelection: Bool = true
    
    var userLocation: YMKPoint? {
        didSet {
            guard userLocation != nil && userLocation?.latitude != 0 && userLocation?.longitude != 0 else { return }

//            if isItFirstSelection {
//                isItFirstSelection = false
//                mapView.mapWindow.map.move(
//                    with: YMKCameraPosition.init(target: userLocation!, zoom: ZOOM, azimuth: 0, tilt: 0),
//                    animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
//                    cameraCallback: nil)
//            }
        }
    }
    
    var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.tintColor = .kexRed
        button.setImage(UIImage(named: "back"), for: .normal)
        button.layer.cornerRadius = 22
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var enableLocationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "location"), for: .normal)
        button.layer.cornerRadius = 22
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var markerView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "marker")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var shadow: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.opacity = 0.7
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let addressSheetVC = AddressSheetController()
    let suggestVC = SuggestController()
    let commentarySheetVC = CommentarySheetController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupMap()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addBottomSheetView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupViews() {
        suggestVC.delegate = self
        suggestVC.targetLocation = targetLocation
        
        addressSheetVC.suggestVC = suggestVC
        addressSheetVC.delegate = self
        
        view.backgroundColor = .white
        view.addSubview(mapView)
        view.addSubview(backButton)
        view.addSubview(enableLocationButton)
        view.addSubview(markerView)
        view.addSubview(shadow)
    }
    
    func setupConstraints() {
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        backButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        
        enableLocationButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        enableLocationButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        enableLocationButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        enableLocationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -235).isActive = true
        
        markerView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        markerView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        markerView.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        markerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        shadow.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        shadow.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        shadow.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        shadow.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupMap() {
        locationManager.delegate = self
        
        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: targetLocation, zoom: ZOOM, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
        mapView.mapWindow.map.addCameraListener(with: self)
        mapView.mapWindow.map.isRotateGesturesEnabled = false
        
        let mapKit = YMKMapKit.sharedInstance()
        let userLocationLayer = mapKit.createUserLocationLayer(with: mapView.mapWindow)

        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.setObjectListenerWith(self)
    }
    
    func addBottomSheetView(scrollable: Bool? = true) {
        self.addChild(addressSheetVC)
        self.view.addSubview(addressSheetVC.view)
        addressSheetVC.didMove(toParent: self)
        addressSheetVC.modalPresentationStyle = .pageSheet
        let height: CGFloat = 211.0
        let width  = view.frame.width
        addressSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
    
    @objc func backButtonTapped(_ sender:UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func imageButtonTapped(_ sender:UIButton!) {
        print("BUTTON TAPPED")
        let locStatus = CLLocationManager.authorizationStatus()
        switch locStatus {
          case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            print("not determined")
            return
          case .denied, .restricted:
            let alert = UIAlertController(title: "Location Services are disabled", message: "Please enable Location Services in your Settings", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
          case .authorizedAlways, .authorizedWhenInUse:
            print("case always and when in user")
            break
        }
        locationManager.startUpdatingLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.userLocation != nil {
                self.mapView.mapWindow.map.move(
                    with: YMKCameraPosition.init(target: self.userLocation!, zoom: ZOOM, azimuth: 0, tilt: 0),
                    animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
                    cameraCallback: nil)
            }
        }
    }
}

extension MapViewController: YMKUserLocationObjectListener {
    func onObjectAdded(with view: YMKUserLocationView) {
//FIXME: - should map show the user's location from locationManager?
        let pinPlacemark = view.pin.useCompositeIcon()
        pinPlacemark.setIconWithName(
            "pin",
            image: UIImage(named:"SearchResult")!,
            style:YMKIconStyle(
                anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
                rotationType: YMKRotationType.rotate.rawValue as NSNumber,
                zIndex: 1,
                flat: false,
                visible: true,
                scale: 1,
                tappableArea: nil))
        view.accuracyCircle.fillColor = .clear
    }
    
    func onObjectRemoved(with view: YMKUserLocationView) {
        print("removed object")
    }
    
    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {
        print("object updated")
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = YMKPoint(latitude: locations.last!.coordinate.latitude, longitude: locations.last!.coordinate.longitude)
    }
}

extension MapViewController: YMKMapCameraListener {
    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateSource: YMKCameraUpdateSource, finished: Bool) {
        if finished {
            let point = map.cameraPosition.target
            let zoom = map.cameraPosition.zoom as NSNumber
            print(point.latitude, point.longitude)
            // MARK: bool value
            getName(point: point, zoom: zoom)
            print("camera position changed")
        }
    }
}


extension MapViewController {
    func onSearchResponseName(_ response: YMKSearchResponse) {
        print("searchResponse started")
        for searchResult in response.collection.children {
            if let _ = searchResult.obj!.geometry.first?.point {
                print(response.collection.children[0].obj!.name!)
                guard let objMetadata = response.collection.children[0].obj!.metadataContainer.getItemOf(YMKSearchToponymObjectMetadata.self) as? YMKSearchToponymObjectMetadata else {
                    continue
                }
//MARK: - checking if object is KindHome type
//                if objMetadata.address.components.count >= 5 {
                    addressSheetVC.changeAddress(address: response.collection.children[0].obj!.name!)
                    print("searchResponse done")
                    return
//                }
            }
        }
        print("searchResponse done")
    }
    
    func getName(point : YMKPoint, zoom : NSNumber){
        let responseHandler = {(searchResponse: YMKSearchResponse?, error: Error?) -> Void in
            if let response = searchResponse {
                self.onSearchResponseName(response)
            } else {
                //TODO: Error for search
                //  self.onSearchError(error!)
            }
        }
        searchSession = searchManager.submit(with: point, zoom: zoom, searchOptions: YMKSearchOptions(), responseHandler: responseHandler)
    }
}

extension MapViewController: MapDelegate {
    func dissmissView(viewName: String) {
        print("x")
    }
    
    func hideCommentarySheet() {
        addressSheetVC.view.isHidden = false
    }
    
    func showCommentarySheet() {
        addressSheetVC.view.isHidden = true
        
        self.addChild(commentarySheetVC)
        self.view.addSubview(commentarySheetVC.view)
        commentarySheetVC.delegate = self
        commentarySheetVC.didMove(toParent: self)
        commentarySheetVC.modalPresentationStyle = .overCurrentContext
        
        let height: CGFloat = 149.0
        let width  = view.frame.width
        commentarySheetVC.view.frame = CGRect(x: 0, y: self.view.frame.height - height, width: width, height: height)
        print("view frame height: \(self.view.frame.height)")
    }
    
    func passCommentary(text: String) {
        addressSheetVC.changeComment(comment: text)
    }
    
    func reverseGeocoding(searchQuery: String, title: String) {
        print("passData Started")
        addressSheetVC.changeAddress(address: title)
        let responseHandler = {(searchResponse: YMKSearchResponse?, error: Error?) -> Void in
            if let response = searchResponse {
                for searchResult in response.collection.children {
                    if let _ = searchResult.obj!.geometry.first?.point {
                        print(response.collection.children[0].obj!.name!)
                        guard let objMetadata = response.collection.children[0].obj!.metadataContainer.getItemOf(YMKSearchToponymObjectMetadata.self) as? YMKSearchToponymObjectMetadata else {
                            continue
                        }
//MARK: - checking if object is KindHome type
//                        if objMetadata.address.components.count >= 5 {
                            self.mapView.mapWindow.map.move(
                                with: YMKCameraPosition.init(target: YMKPoint(latitude: objMetadata.balloonPoint.latitude, longitude: objMetadata.balloonPoint.longitude), zoom: ZOOM, azimuth: 0, tilt: 0),
                                animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 3),
                                cameraCallback: nil)
                            print("passData from mapdelegate is done")
//                        }
                    }
                }
                self.onSearchResponseName(response)
            } else {
                //TODO: - Search error for reverseGeocoding
                //  self.onSearchError(error!)
            }
        }
        
        searchSession = searchManager.submit(withText: searchQuery, geometry: YMKGeometry(point: targetLocation), searchOptions: YMKSearchOptions(), responseHandler: responseHandler)
    }
    
    func mapShadow(toggle: Bool) {
        if toggle {
            shadow.isHidden = false
        } else {
            shadow.isHidden = true
        }
    }
}
