//
//  LocationManager.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 03.06.2021.
//

import CoreLocation
import Foundation

protocol LocationManagerDelegate: AnyObject {
    func didChangeLocation(latitude: Double, longtitude: Double)
    func askUserForPermission()
}

final class LocationManager: NSObject {
    weak var delegate: LocationManagerDelegate?

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }

    func getCurrentLocation() {
        let status = CLLocationManager.authorizationStatus()

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        case .restricted, .denied:
            delegate?.askUserForPermission()
            return
        case .authorizedAlways, .authorizedWhenInUse: break
        @unknown default:
            break
        }

        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        locationManager.stopUpdatingLocation()
        delegate?.didChangeLocation(latitude: Double(lastLocation.coordinate.latitude), longtitude: Double(lastLocation.coordinate.longitude))
    }
}
