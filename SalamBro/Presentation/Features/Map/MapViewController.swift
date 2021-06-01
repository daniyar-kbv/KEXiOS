//
//  ViewController.swift
//  yandex-map
//
//  Created by Arystan on 3/31/21.
//

import CoreLocation
import UIKit
import YandexMapKit
import YandexMapKitSearch

class MapViewController: ViewController {
    var targetLocation = YMKPoint(latitude: ALA_LAT, longitude: ALA_LON)
    let locationManager = CLLocationManager()
    let searchManager = YMKSearch.sharedInstance().createSearchManager(with: .online)
    var searchSession: YMKSearchSession?
    private let geoRepository = DIResolver.resolve(GeoRepository.self)! // TODO:
    private let coordinator = DIResolver.resolve(AppCoordinator.self)! // TODO:

    var selectedAddress: ((String) -> Void)?
    var isAddressChangeFlow: Bool = false

    var mapView: YMKMapView = {
        let view = YMKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var userLocation: YMKPoint? {
        didSet {
            guard userLocation != nil, userLocation?.latitude != 0, userLocation?.longitude != 0 else { return }
        }
    }

    private lazy var backButton: MapActionButton = {
        let btn = MapActionButton(image: Asset.chevronLeft.image)
        btn.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return btn
    }()

    private lazy var locationButton: MapActionButton = {
        let btn = MapActionButton(image: Asset.location.image)
        btn.addTarget(self, action: #selector(locationButtonAction), for: .touchUpInside)
        return btn
    }()

    var markerView: UIImageView = {
        let view = UIImageView()
        view.image = Asset.marker.image
        view.contentMode = .scaleAspectFit
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
        locationManager.requestWhenInUseAuthorization()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addBottomSheetView()
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func setupViews() {
        suggestVC.delegate = self
        suggestVC.targetLocation = targetLocation

        addressSheetVC.suggestVC = suggestVC
        addressSheetVC.delegate = self

        view.backgroundColor = .white
        view.addSubview(mapView)
        view.addSubview(backButton)
        view.addSubview(locationButton)
        view.addSubview(markerView)
        view.addSubview(shadow)
    }

    func setupConstraints() {
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.size.equalTo(44)
            $0.leading.equalToSuperview().offset(24)
        }

        let width = view.frame.size.width
        markerView.widthAnchor.constraint(equalToConstant: width * 0.15).isActive = true
        markerView.heightAnchor.constraint(equalToConstant: (width * 0.15) * 1.22).isActive = true
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
            with: YMKCameraPosition(target: targetLocation, zoom: ZOOM, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0),
            cameraCallback: nil
        )
        mapView.mapWindow.map.addCameraListener(with: self)
        mapView.mapWindow.map.isRotateGesturesEnabled = false
    }

    func addBottomSheetView(scrollable _: Bool? = true) {
        addChild(addressSheetVC)
        view.addSubview(addressSheetVC.view)
        addressSheetVC.didMove(toParent: self)
        addressSheetVC.modalPresentationStyle = .pageSheet

        let height: CGFloat = 211 // UIScreen.main.bounds.height * 0.32
        let width = view.frame.width

        addressSheetVC.view.frame = CGRect(x: 0, y: view.frame.height - height, width: width, height: height) // + bottomPadding!

        locationButton.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.leading.equalToSuperview().offset(24)
            $0.bottom.equalTo(addressSheetVC.view.snp.top).offset(-24)
        }
    }

    @objc func backButtonTapped(_: UIButton!) {
        if isAddressChangeFlow {
            dismiss(animated: true, completion: nil)
        }

        navigationController?.popViewController(animated: true)
    }

    @objc func locationButtonAction(_: UIButton!) {
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
        @unknown default:
            fatalError()
        }
        locationManager.startUpdatingLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.userLocation != nil {
                self.mapView.mapWindow.map.move(
                    with: YMKCameraPosition(target: self.userLocation!, zoom: ZOOM, azimuth: 0, tilt: 0), animationType: .init(type: .linear, duration: 0),
                    cameraCallback: nil
                )
            }
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = YMKPoint(latitude: locations.last!.coordinate.latitude, longitude: locations.last!.coordinate.longitude)
    }
}

extension MapViewController: YMKMapCameraListener {
    func onCameraPositionChanged(with map: YMKMap, cameraPosition _: YMKCameraPosition, cameraUpdateSource _: YMKCameraUpdateSource, finished: Bool) {
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
        for searchResult in response.collection.children {
            if let _ = searchResult.obj!.geometry.first?.point {
                guard let objMetadata = response.collection.children[0].obj!.metadataContainer.getItemOf(YMKSearchToponymObjectMetadata.self) as? YMKSearchToponymObjectMetadata else {
                    continue
                }

                let address = searchResult.obj?.name ?? objMetadata.address.formattedAddress

                addressSheetVC.changeAddress(address: address,
                                             longitude: objMetadata.balloonPoint.longitude,
                                             latitude: objMetadata.balloonPoint.latitude)
                return
            }
        }
    }

    func getName(point: YMKPoint, zoom: NSNumber) {
        let responseHandler = { (searchResponse: YMKSearchResponse?, _: Error?) -> Void in
            if let response = searchResponse {
                self.onSearchResponseName(response)
            } else {
                // TODO: Error for search
                //  self.onSearchError(error!)
            }
        }
        searchSession = searchManager.submit(with: point, zoom: zoom, searchOptions: YMKSearchOptions(), responseHandler: responseHandler)
    }
}

extension MapViewController: MapDelegate {
    func dissmissView() {
        if isAddressChangeFlow,
           let address = geoRepository.currentAddress?.name
        {
            selectedAddress?(address)
            dismiss(animated: true, completion: nil)
            return
        }

        coordinator.start()
    }

    func hideCommentarySheet() {
        addressSheetVC.view.isHidden = false
    }

    func showCommentarySheet() {
        addressSheetVC.view.isHidden = true

        addChild(commentarySheetVC)
        view.addSubview(commentarySheetVC.view)
        commentarySheetVC.delegate = self
        commentarySheetVC.didMove(toParent: self)
        commentarySheetVC.modalPresentationStyle = .overCurrentContext

        let height: CGFloat = 149.0
        let width = view.frame.width
        commentarySheetVC.view.frame = CGRect(x: 0, y: view.frame.height - height, width: width, height: height)
        print("view frame height: \(view.frame.height)")
    }

    func passCommentary(text: String) {
        addressSheetVC.changeComment(comment: text)
    }

    func reverseGeocoding(searchQuery: String, title _: String) {
        print("passData Started")
        let responseHandler = { (searchResponse: YMKSearchResponse?, _: Error?) -> Void in
            if let response = searchResponse {
                for searchResult in response.collection.children {
                    if let _ = searchResult.obj!.geometry.first?.point {
                        print(response.collection.children[0].obj!.name!)
                        guard let objMetadata = response.collection.children[0].obj!.metadataContainer.getItemOf(YMKSearchToponymObjectMetadata.self) as? YMKSearchToponymObjectMetadata else {
                            continue
                        }

                        self.addressSheetVC.changeAddress(address: objMetadata.address.formattedAddress,
                                                          longitude: objMetadata.balloonPoint.longitude,
                                                          latitude: objMetadata.balloonPoint.latitude)

                        // MARK: - checking if object is KindHome type

//                        if objMetadata.address.components.count >= 5 {
                        self.mapView.mapWindow.map.move(
                            with: YMKCameraPosition(target: YMKPoint(latitude: objMetadata.balloonPoint.latitude, longitude: objMetadata.balloonPoint.longitude), zoom: ZOOM, azimuth: 0, tilt: 0),
                            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
                            cameraCallback: nil
                        )
                        print("passData from mapdelegate is done")
//                        }
                    }
                }
                self.onSearchResponseName(response)
            } else {
                // TODO: - Search error for reverseGeocoding
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
