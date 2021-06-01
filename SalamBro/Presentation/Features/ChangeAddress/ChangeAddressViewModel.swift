//
//  ChangeAddressViewModel.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 19.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol ChangeAddressViewModel: AnyObject {
    var coordinator: ChangeAddressCoordinator { get }
    
    func getCellModel(for indexPath: IndexPath) -> ChangeAddressDTO
    func checkInputs()
    func getCellsCount() -> Int
    func changeRoute(indexPath: IndexPath)
    func changeAddress(completion: @escaping () -> Void)
    func didFinish()

    var outputs: ChangeAddressViewModelImpl.Output { get }
}

final class ChangeAddressViewModelImpl: ChangeAddressViewModel {
    internal let coordinator: ChangeAddressCoordinator
    private(set) var outputs = Output()
    private var city: City?
    private var country: Country?
    private var brand: Brand?
    private var address: String?

    private(set) var cellModels: [ChangeAddressDTO] = [
        ChangeAddressDTO(isSelected: false, description: nil, accessoryType: .none, inputType: .country),
        ChangeAddressDTO(isSelected: false, description: nil, accessoryType: .none, inputType: .city),
        ChangeAddressDTO(isSelected: false, description: nil, accessoryType: .disclosureIndicator, inputType: .address),
        ChangeAddressDTO(isSelected: false, description: nil, accessoryType: .none, inputType: .empty),
        ChangeAddressDTO(isSelected: false, description: nil, accessoryType: .disclosureIndicator, inputType: .brand),
    ]

    init(coordinator: ChangeAddressCoordinator) {
        self.coordinator = coordinator
        checkInputs()
    }

    func changeAddress(completion: @escaping () -> Void) {
        coordinator.alert(title: "Успешно", message: "Адрес изменен") {
            completion()
        }
    }

    func checkInputs() {
        if
            let _ = city,
            let _ = country,
            let _ = brand,
            let _ = address
        {
            outputs.didEnterValidInputs.accept(true)
            return
        }
        outputs.didEnterValidInputs.accept(false)
    }

    func getCellModel(for indexPath: IndexPath) -> ChangeAddressDTO {
        return cellModels[indexPath.row]
    }

    func getCellsCount() -> Int {
        return cellModels.count
    }

    func changeRoute(indexPath: IndexPath) {
        var cellModel = cellModels[indexPath.row]
        
        switch cellModel.inputType {
        case .address:
            coordinator.openMap()
            coordinator.selectedAddress = { [weak self] address in
                cellModel.description = address
                self?.address = address
                self?.cellModels[indexPath.row] = cellModel
                self?.outputs.reloadCellAt.accept(indexPath)
            }
        case .brand:
            coordinator.openBrand()
            coordinator.selectedBrand = { [weak self] brand in
                cellModel.description = brand.name
                self?.brand = brand
                self?.cellModels[indexPath.row] = cellModel
                self?.outputs.reloadCellAt.accept(indexPath)
            }
        case .city:
            guard let countryId = country?.id else {
                coordinator.alert(title: "Ошибка", message: "Пожалуйста, выберите сначала страну")
                return
            }

            coordinator.openCities(countryId: countryId)
            coordinator.selectedCity = { [weak self] city in
                cellModel.description = city.name
                self?.city = city
                self?.cellModels[indexPath.row] = cellModel
                self?.outputs.reloadCellAt.accept(indexPath)
            }
        case .country:
            coordinator.openCountries()
            coordinator.selectedCountry = { [weak self] country in
                cellModel.description = country.name
                self?.country = country
                self?.cellModels[indexPath.row] = cellModel
                self?.outputs.reloadCellAt.accept(indexPath)
            }
        case .empty: break
        }

        checkInputs()
    }
    
    func didFinish() {
        coordinator.onFinish()
    }

    struct Output {
        let reloadCellAt = PublishRelay<IndexPath>()
        let didEnterValidInputs = PublishRelay<Bool>()
    }
}
