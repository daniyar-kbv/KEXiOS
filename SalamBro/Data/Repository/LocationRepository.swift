//
//  LocationRepository.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 27.05.2021.
//

import Foundation

protocol LocationRepository: AnyObject {
    func isAddressComplete() -> Bool
    
    func getCurrentCountry() -> Country?
    func getCountries() -> [Country]?
    func changeCurrentCountry(to country: Country)
    func set(countries: [Country])

    func getCurrectCity() -> City?
    func getCities() -> [City]?
    func changeCurrentCity(to city: City)
    func set(cities: [City])
    
    func getCurrentAddress() -> Address?
    func changeCurrentAddress(to address: Address)
    
    func getDeliveryAddresses() -> [DeliveryAddress]?
    func setDeliveryAddressses(deliveryAddresses: [DeliveryAddress])
    func getCurrentDeliveryAddress() -> DeliveryAddress?
    func setCurrentDeliveryAddress(deliveryAddress: DeliveryAddress?)
    func deleteDeliveryAddress(deliveryAddress: DeliveryAddress)
    func addDeliveryAddress(deliveryAddress: DeliveryAddress)
}

final class LocationRepositoryImpl: LocationRepository {
    private let storage: GeoStorage

    init(storage: GeoStorage) {
        self.storage = storage
    }
}

extension LocationRepositoryImpl {
    func isAddressComplete() -> Bool {
        return getCurrentDeliveryAddress()?.isComplete() ?? false
    }
}

// MARK: Countries

extension LocationRepositoryImpl {
    func getCurrentCountry() -> Country? {
        return getCurrentDeliveryAddress()?.country
    }

    func getCountries() -> [Country]? {
        guard
            let countries = storage.countries,
            countries != []
        else {
            return nil
        }

        return countries
    }

    func changeCurrentCountry(to country: Country) {
        if let index = storage.currentDeliveryAddressIndex {
            storage.deliveryAddresses?[index].country = country
        } else {
            addDeliveryAddress(deliveryAddress: DeliveryAddress(country: country))
        }
    }

    func set(countries: [Country]) {
        storage.countries = countries
    }
}

// MARK: Cities

extension LocationRepositoryImpl {
    func getCurrectCity() -> City? {
        return getCurrentDeliveryAddress()?.city
    }

    func getCities() -> [City]? {
        guard
            let cities = storage.cities,
            cities != []
        else {
            return nil
        }

        return cities
    }

    func changeCurrentCity(to city: City) {
        if let index = storage.currentDeliveryAddressIndex {
            storage.deliveryAddresses?[index].city = city
        } else {
            addDeliveryAddress(deliveryAddress: DeliveryAddress(city: city))
        }
    }

    func set(cities: [City]) {
        storage.cities = cities
    }
}

//  MARK: Address

extension LocationRepositoryImpl {
    func getCurrentAddress() -> Address? {
        return getCurrentDeliveryAddress()?.address
    }
    
    func changeCurrentAddress(to address: Address) {
        if let index = storage.currentDeliveryAddressIndex {
            storage.deliveryAddresses?[index].address = address
        } else {
            addDeliveryAddress(deliveryAddress: DeliveryAddress(address: address))
        }
    }
}

// MARK: DeliveryAddress

extension LocationRepositoryImpl {
    func getDeliveryAddresses() -> [DeliveryAddress]? {
        return storage.deliveryAddresses
    }
    
    func setDeliveryAddressses(deliveryAddresses: [DeliveryAddress]) {
        storage.deliveryAddresses = deliveryAddresses
    }
    
    func getCurrentDeliveryAddress() -> DeliveryAddress? {
        guard let index = storage.currentDeliveryAddressIndex else { return nil }
        return storage.deliveryAddresses?[index]
    }
    
    func setCurrentDeliveryAddress(deliveryAddress: DeliveryAddress?) {
        storage.currentDeliveryAddressIndex = storage.deliveryAddresses?.firstIndex(where: { $0 == deliveryAddress })
    }
    
    func deleteDeliveryAddress(deliveryAddress: DeliveryAddress) {
        var wasCurrent = false
        if let index = storage.currentDeliveryAddressIndex,
           storage.deliveryAddresses?[index] == deliveryAddress {
            wasCurrent = true
        }
        storage.deliveryAddresses?.removeAll(where: { $0 == deliveryAddress })
        if wasCurrent {
            setCurrentDeliveryAddress(deliveryAddress: storage.deliveryAddresses?.first)
        }
    }
        
    func addDeliveryAddress(deliveryAddress: DeliveryAddress) {
        var tmpDeliveryAddresses: [DeliveryAddress]
        if let addresses = storage.deliveryAddresses {
            tmpDeliveryAddresses = addresses
        } else {
            tmpDeliveryAddresses = []
        }
        tmpDeliveryAddresses.append(deliveryAddress)
        storage.deliveryAddresses = tmpDeliveryAddresses
        storage.currentDeliveryAddressIndex = storage.deliveryAddresses?.firstIndex(where: { $0 == deliveryAddress })
    }
}


