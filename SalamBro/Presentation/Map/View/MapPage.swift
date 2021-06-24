//
//  MapPage.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 02.06.2021.
//

import RxCocoa
import RxSwift
import UIKit
import YandexMapKit

final class MapPage: UIViewController, AlertDisplayable, LoaderDisplayable {
    var selectedAddress: ((Address) -> Void)?

    private let disposeBag = DisposeBag()

    private let yandexMapView: YMKMapView = {
        let mapView = YMKMapView(frame: .zero)
        return mapView
    }()

    private let mapAddressView = MapAddressView()
    private let backButton = MapActionButton(image: Asset.chevronLeft.image)
    private let locationButton = MapActionButton(image: Asset.location.image)
    private let pinView = UIImageView(image: Asset.marker.image)

    private let viewModel: MapViewModel
    private let locationManager: LocationManager = .init()

    private var searchPage: SuggestController?
    private var commentaryPage: MapCommentaryPage?

    private var isBottom: Bool {
        if #available(iOS 11.0, *), let keyWindow = UIApplication.shared.keyWindow, keyWindow.safeAreaInsets.bottom > 0 {
            return true
        }
        return false
    }

    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        locationManager.delegate = self
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        bindViews()
        bindViewModel()
        configureMap()
        configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension MapPage: LocationManagerDelegate {
    func askUserForPermission() {
        showAlert(title: "Location Services are disabled", message: "Please enable Location Services in your Settings")
    }

    func didChangeLocation(latitude: Double, longtitude: Double) {
        viewModel.currentLocation = YMKPoint(latitude: latitude, longitude: longtitude)
        guard let position = viewModel.currentLocation else { return }
        yandexMapView.mapWindow.map.move(with: YMKCameraPosition(target: position, zoom: ZOOM, azimuth: 0, tilt: 0))
    }
}

// MARK: Yandex Map

extension MapPage: YMKMapCameraListener {
    private func configureMap() {
        moveMap(to: viewModel.targetLocation)
        yandexMapView.mapWindow.map.addCameraListener(with: self)
        yandexMapView.mapWindow.map.isRotateGesturesEnabled = false
    }

    func onCameraPositionChanged(with map: YMKMap, cameraPosition _: YMKCameraPosition, cameraUpdateSource _: YMKCameraUpdateSource, finished: Bool) {
        guard finished else { return }
        let point = map.cameraPosition.target
        let zoom = map.cameraPosition.zoom as NSNumber
        viewModel.getName(point: point, zoom: zoom)
    }

    private func moveMap(to point: YMKPoint) {
        yandexMapView.mapWindow.map.move(with: YMKCameraPosition(target: point,
                                                                 zoom: ZOOM,
                                                                 azimuth: 0,
                                                                 tilt: 0),
                                         animationType: YMKAnimation(type: .smooth, duration: 0),
                                         cameraCallback: nil)
    }
}

// MARK: Binding

extension MapPage {
    private func bindViewModel() {
        viewModel.outputs.selectedAddress
            .subscribe(onNext: { [weak self] mapAddress in
                self?.mapAddressView.addressTextField.text = mapAddress.name
                self?.mapAddressView.changeButtonAppearance(based: mapAddress.name)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.moveMapTo
            .subscribe(onNext: { [weak self] point in
                self?.moveMap(to: point)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.lastSelectedAddress
            .subscribe(onNext: { [weak self] address in
                self?.handlePageTermination()
                self?.selectedAddress?(Address(name: address.name,
                                               longitude: address.longitude,
                                               latitude: address.latitude,
                                               commentary: self?.mapAddressView.commentaryTextField.text))
            })
            .disposed(by: disposeBag)

        viewModel.outputs.didGetError
            .subscribe(onNext: { [weak self] error in
                self?.showError(error)
            }).disposed(by: disposeBag)

        viewModel.outputs.didStartRequest
            .subscribe(onNext: { [weak self] in
                self?.showLoader()
            }).disposed(by: disposeBag)

        viewModel.outputs.didFinishRequest
            .subscribe(onNext: { [weak self] in
                self?.hideLoader()
            }).disposed(by: disposeBag)
    }

    private func bindViews() {
        backButton.rx.tap
            .bind { [weak self] in
                self?.handlePageTermination()
            }
            .disposed(by: disposeBag)

        locationButton.rx.tap
            .bind { [weak self] in
                self?.locationManager.getCurrentLocation()
            }
            .disposed(by: disposeBag)

        mapAddressView.actionButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.onActionButtonTapped()
            }
            .disposed(by: disposeBag)

        mapAddressView.addressTextField.rx
            .controlEvent(.touchDown)
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.showAddressSearchPage()
            })
            .disposed(by: disposeBag)

        mapAddressView.commentaryTextField.rx
            .controlEvent(.touchDown)
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.showCommentaryPage()
            })
            .disposed(by: disposeBag)
    }

    private func handlePageTermination() {
        switch viewModel.flow {
        case .change: dismiss(animated: true, completion: nil)
        case .creation: navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: Modal Present Commentary and Search Pages

extension MapPage {
    private func showAddressSearchPage() {
        searchPage = SuggestController()
        guard let page = searchPage else { return }
        page.suggestDelegate = self
        present(page, animated: true, completion: nil)
    }

    private func showCommentaryPage() {
        commentaryPage = MapCommentaryPage()
        guard let page = commentaryPage else { return }
        page.cachedCommentary = mapAddressView.commentaryTextField.text
        page.configureTextField(placeholder: L10n.Commentary.AddressField.title)
        page.delegate = self
        present(page, animated: true, completion: nil)
    }
}

// MARK: Commentary and Search Delegates

extension MapPage: MapCommentaryPageDelegate, SuggestControllerDelegate {
    func onDoneButtonTapped(commentary: String) {
        mapAddressView.commentaryTextField.text = commentary
    }

    func reverseGeocoding(searchQuery: String, title: String) {
        viewModel.reverseGeoCoding(searchQuery: searchQuery, title: title)
    }
}

// MARK: Layout UI

extension MapPage {
    private func layoutUI() {
        view.backgroundColor = .arcticWhite
        view.addSubview(yandexMapView)
        yandexMapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.size.equalTo(44)
            $0.leading.equalToSuperview().offset(24)
        }

        view.addSubview(pinView)
        pinView.contentMode = .scaleAspectFit
        let width = view.frame.size.width
        pinView.snp.makeConstraints {
            $0.height.equalTo((width * 0.15) * 1.22)
            $0.width.equalTo(width * 0.15)
            $0.center.equalToSuperview()
        }

        view.addSubview(mapAddressView)
        mapAddressView.snp.makeConstraints {
            if isBottom {
                $0.height.equalTo(240)
            } else {
                $0.height.equalTo(211)
            }
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }

        view.addSubview(locationButton)
        locationButton.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.leading.equalToSuperview().offset(24)
            $0.bottom.equalTo(mapAddressView.snp.top).offset(-24)
        }
    }
}

//  MARK: Configure view

extension MapPage {
    func configureView() {
        mapAddressView.commentaryTextField.text = viewModel.commentary
    }
}
