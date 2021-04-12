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

protocol MapDelegate {
    func passData(searchQuery: String, title: String)
    func mapShadow(toggle: Bool)
    func showCommentarySheet()
    func hideCommentarySheet()
    func passCommentary(text: String)
}

class MapViewController: UIViewController {
    
    var targetLocation = YMKPoint(latitude: 43.222015, longitude: 76.851250)
    let locationManager = CLLocationManager()
    let searchManager = YMKSearch.sharedInstance().createSearchManager(with: .online)
    var searchSession: YMKSearchSession?
    let ZOOM: Float = 18.0
    
    var mapView: YMKMapView = {
        let view = YMKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var backButton: UIButton = {
       let button = UIButton()
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
        suggestVC.delegate = self
        suggestVC.targetLocation = targetLocation
        locationManager.delegate = self
        addressSheetVC.suggestVC = suggestVC
        addressSheetVC.delegate = self
        setupViews()
        setupConstraints()
        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: targetLocation, zoom: ZOOM, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
        mapView.mapWindow.map.addCameraListener(with: self)
        mapView.mapWindow.map.isRotateGesturesEnabled = false
        
        let scale = UIScreen.main.scale
        let mapKit = YMKMapKit.sharedInstance()
        let userLocationLayer = mapKit.createUserLocationLayer(with: mapView.mapWindow)

        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.isHeadingEnabled = true
        userLocationLayer.setAnchorWithAnchorNormal(
            CGPoint(x: 0.5 * mapView.frame.size.width * scale, y: 0.5 * mapView.frame.size.height * scale),
            anchorCourse: CGPoint(x: 0.5 * mapView.frame.size.width * scale, y: 0.83 * mapView.frame.size.height * scale))
        userLocationLayer.setObjectListenerWith(self)
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
        view.backgroundColor = .white
        view.addSubview(mapView)
        view.addSubview(enableLocationButton)
        view.addSubview(markerView)
        view.addSubview(shadow)
    }
    
    func setupConstraints() {
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
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
    
    func addBottomSheetView(scrollable: Bool? = true) {
        self.addChild(addressSheetVC)
        self.view.addSubview(addressSheetVC.view)
        addressSheetVC.didMove(toParent: self)
        addressSheetVC.modalPresentationStyle = .pageSheet
           // 3- Adjust bottomSheet frame and initial position.
        let height: CGFloat = 211.0
        let width  = view.frame.width
        addressSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
    
    @objc func imageButtonTapped(_ sender:UIButton!) {
        let locStatus = CLLocationManager.authorizationStatus()
        switch locStatus {
          case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            print("not determined")
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
        //        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//                locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
//        print("tapped")
        focusToCurrentPosition()
    }
    
    @objc func proceedToCommentary() {
//        bottomSheetVC.view.removeFromSuperview()
//        bottomSheetVC.removeFromParent()
    }
}

extension MapViewController {
    func focusToCurrentPosition() {
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
//        let newLocation = YMKPoint(latitude: locValue.latitude, longitude: locValue.longitude)
        targetLocation = YMKPoint(latitude: locValue.latitude, longitude: locValue.longitude)
        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: targetLocation, zoom: ZOOM, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 3),
            cameraCallback: nil)
    }
}

extension MapViewController: YMKUserLocationObjectListener {
    func onObjectAdded(with view: YMKUserLocationView) {
        let pinPlacemark = view.pin.useCompositeIcon()
        pinPlacemark.setIconWithName(
            "pin",
            image: UIImage(named:"SearchResult")!,
            style:YMKIconStyle(
                anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
                rotationType:YMKRotationType.rotate.rawValue as NSNumber,
                zIndex: 1,
                flat: true,
                visible: true,
                scale: 1,
                tappableArea: nil))

        view.accuracyCircle.fillColor = UIColor.blue
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
        focusToCurrentPosition()
        print("location changed")
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
                if objMetadata.address.components.count >= 5 {
                    addressSheetVC.changeAddress(address: response.collection.children[0].obj!.name!)
                    print("searchResponse done")
                    return
                }
            }
        }
        print("searchResponse done")
    }
    
    func getName(point : YMKPoint, zoom : NSNumber){
        let responseHandler = {(searchResponse: YMKSearchResponse?, error: Error?) -> Void in
            if let response = searchResponse {
                self.onSearchResponseName(response)
            } else {
                //  self.onSearchError(error!)
            }
        }
        searchSession = searchManager.submit(with: point, zoom: zoom, searchOptions: YMKSearchOptions(), responseHandler: responseHandler)
    }
}

extension MapViewController: MapDelegate {
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
    
    func passData(searchQuery: String, title: String) {
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
//                        if objMetadata.address.components.count >= 5 {
                            self.mapView.mapWindow.map.move(
                                with: YMKCameraPosition.init(target: YMKPoint(latitude: objMetadata.balloonPoint.latitude, longitude: objMetadata.balloonPoint.longitude), zoom: self.ZOOM, azimuth: 0, tilt: 0),
                                animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 3),
                                cameraCallback: nil)
                            print("passData from mapdelegate is done")
//                        }
                    }
                }
                self.onSearchResponseName(response)
            } else {
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
