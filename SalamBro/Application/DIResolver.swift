//
//  DIResolver.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation
import Swinject

public final class DIResolver {
    private static let assembler = Assembler([
        ApplicationAssembly(),
        ProvidersAssembly(),
        StoragesAssembly(),
        ManagersAssembly(),
        RepositoriesAssembly(),
    ])

    class func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        assembler.resolver.resolve(serviceType)
    }

    class func resolve<Service, Arg1>(_ serviceType: Service.Type, argument: Arg1) -> Service? {
        assembler.resolver.resolve(serviceType, argument: argument)
    }

    class func resolve<Service, Arg1, Arg2>(_ serviceType: Service.Type, argument1 arg1: Arg1, argument2 arg2: Arg2) -> Service? {
        assembler.resolver.resolve(serviceType, arguments: arg1, arg2)
    }
}

private final class ApplicationAssembly: Assembly {
    func assemble(container _: Container) {
        // TODO:
    }
}

private final class ProvidersAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NetworkProvider.self) { _ in
            NetworkProvider()
        }.inObjectScope(.container)
    }
}

private final class StoragesAssembly: Assembly {
    func assemble(container _: Container) {
        // TODO:
    }
}

private final class ManagersAssembly: Assembly {
    func assemble(container _: Container) {
        // TODO:
    }
}

private final class RepositoriesAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MenuRepository.self) { r in
            MenuRepositoryImplementation(provider: r.resolve(NetworkProvider.self)!)
        }

        container.register(BrandRepository.self) { r in
            BrandRepositoryImplementation(provider: r.resolve(NetworkProvider.self)!)
        }

        container.register(GeoRepository.self) { r in
            GeoRepositoryImplementation(provider: r.resolve(NetworkProvider.self)!)
        }
    }
}
