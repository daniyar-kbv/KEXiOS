//
//  MenuPagesFactory.swift
//  SalamBro
//
//  Created by Dan on 6/15/21.
//

import Foundation

protocol MenuPagesFactory {
    func makeManuPage() -> MenuController
}

class MenuPagesFactoryIml: MenuPagesFactory {
    func makeManuPage() -> MenuController {
        return .init(viewModel: makeMenuViewModel(),
//                     Tech debt: move MenuScrollService() ?
                     scrollService: MenuScrollService())
    }
    
    private func makeMenuViewModel() -> MenuViewModelProtocol {
        return MenuViewModel(menuRepository: getMenuRepository(),
                             locationRepository: getLocationRepository(),
                             brandRepository: getBrandRepository())
    }
}

//    Tech debt: change to components

extension MenuPagesFactoryIml {
    
    
    func getMenuRepository() -> MenuRepository {
        DIResolver.resolve(MenuRepository.self)!
    }
    
    func getLocationService() -> LocationService {
        return DIResolver.resolve(LocationService.self)!
    }
    
    func getLocationRepository() -> LocationRepository {
        return DIResolver.resolve(LocationRepository.self)!
    }
    
    func getBrandRepository() -> BrandRepository {
        return DIResolver.resolve(BrandRepository.self)!
    }
}
