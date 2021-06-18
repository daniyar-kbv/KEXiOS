//
//  SupportCoordinatorsFactory.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 18.06.2021.
//

import Foundation

protocol SupportCoordinatorsFactory: AnyObject {}

final class SupportCoordinatorsFactoryImpl: SupportCoordinatorsFactory {
    private let router: Router
    private let serviceComponents: ServiceComponents

    init(router: Router, serviceComponents: ServiceComponents) {
        self.router = router
        self.serviceComponents = serviceComponents
    }
}
