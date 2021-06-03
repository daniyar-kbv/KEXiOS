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
    var coordinator: AddressCoordinator { get }

    func getCellModel(for indexPath: IndexPath) -> ChangeAddressDTO
    func getCell(with cellModel: ChangeAddressDTO, for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell
    func checkInputs()
    func getCellsCount() -> Int
    func changeRoute(indexPath: IndexPath)
    func changeAddress(completion: @escaping () -> Void)
    func didFinish()

    var outputs: ChangeAddressViewModelImpl.Output { get }
}

final class ChangeAddressViewModelImpl: ChangeAddressViewModel {
    internal let coordinator: AddressCoordinator
    private(set) var outputs = Output()
    private var city: City?
    private var country: Country?
    private var brand: Brand?
    private var address: String?

    private(set) var cellModels: [ChangeAddressDTO] = [
        ChangeAddressDTO(isSelected: false, description: nil, accessoryType: .none, inputType: .country, isEnabled: true),
        ChangeAddressDTO(isSelected: false, description: nil, accessoryType: .none, inputType: .city, isEnabled: false),
        ChangeAddressDTO(isSelected: false, description: nil, accessoryType: .disclosureIndicator, inputType: .address, isEnabled: false),
        ChangeAddressDTO(isSelected: false, description: nil, accessoryType: .none, inputType: .empty),
        ChangeAddressDTO(isSelected: false, description: nil, accessoryType: .disclosureIndicator, inputType: .brand, isEnabled: false),
    ]

    init(coordinator: AddressCoordinator) {
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

    func getCell(with cellModel: ChangeAddressDTO, for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        switch cellModel.inputType {
        case .brand:
            guard let brandCell = tableView.dequeueReusableCell(withIdentifier: ChangeAddressBrandCell.reuseIdentifier, for: indexPath) as? ChangeAddressBrandCell else {
                fatalError()
            }

            brandCell.configure(dto: cellModel)
            return brandCell
        case .empty:
            guard let emptyCell = tableView.dequeueReusableCell(withIdentifier: ChangeAddressEmptyCell.reuseIdentifier, for: indexPath) as? ChangeAddressEmptyCell else {
                fatalError()
            }

            return emptyCell
        default:
            guard let changeAddressCell = tableView.dequeueReusableCell(withIdentifier: ChangeAddressTableViewCell.reuseIdentifier, for: indexPath) as? ChangeAddressTableViewCell else {
                fatalError()
            }
            changeAddressCell.configure(dto: cellModel)
            return changeAddressCell
        }
    }

    func getCellsCount() -> Int {
        return cellModels.count
    }

    func changeRoute(indexPath: IndexPath) {
        var cellModel = cellModels[indexPath.row]

        switch cellModel.inputType {
        case .address:
            coordinator.openMap { [weak self] address in
                cellModel.description = address
                self?.address = address
                self?.changeState(indexPath: indexPath, description: address)
                self?.cellModels[indexPath.row] = cellModel
                self?.outputs.reloadCellAt.accept(indexPath)
            }
        case .brand:
            coordinator.openBrands { [weak self] brand in
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

            coordinator.openCitiesList(countryId: countryId) { [weak self] city in
                cellModel.description = city.name
                self?.city = city
                self?.changeState(indexPath: indexPath, description: city.name)
                self?.cellModels[indexPath.row] = cellModel
                self?.outputs.reloadCellAt.accept(indexPath)
            }
        case .country:
            coordinator.openCountriesList { [weak self] country in
                cellModel.description = country.name
                self?.country = country
                self?.changeState(indexPath: indexPath, description: country.name)
                self?.cellModels[indexPath.row] = cellModel
                self?.outputs.reloadCellAt.accept(indexPath)
            }
        case .empty: break
        }

        checkInputs()
    }

    func changeState(indexPath: IndexPath, description: String) {
        let cellModel = cellModels[indexPath.row]

        switch cellModel.inputType {
        case .address:
            if !description.isEmpty { cellModels[4].isEnabled = true }
        case .brand:
            break
        case .city:
            if !description.isEmpty { cellModels[2].isEnabled = true }
        case .country:
            if !description.isEmpty { cellModels[1].isEnabled = true }
        case .empty: break
        }
    }

    func didFinish() {
        coordinator.didFinish()
    }

    struct Output {
        let reloadCellAt = PublishRelay<IndexPath>()
        let didEnterValidInputs = PublishRelay<Bool>()
    }
}
