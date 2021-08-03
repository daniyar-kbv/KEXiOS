//
//  AddressListViewModel.swift
//  SalamBro
//
//  Created by Dan on 7/1/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol AddressListViewModel {
    var outputs: AddressListViewModelImpl.Output { get }
    var userAddreses: [UserAddress] { get set }

    func getAddresses()
}

final class AddressListViewModelImpl: AddressListViewModel {
    private let disposeBag = DisposeBag()
    private let addressRepository: AddressRepository

    let outputs = Output()

    var userAddreses = [UserAddress]()

    init(addressRepository: AddressRepository) {
        self.addressRepository = addressRepository

        bindRepository()
    }

    private func bindRepository() {
        addressRepository.outputs.didGetUserAddresses
            .subscribe(onNext: { [weak self] userAddresses in
                self?.userAddreses = userAddresses
                self?.outputs.reload.accept(())
            })
            .disposed(by: disposeBag)
    }

    func getAddresses() {
        addressRepository.getUserAddresses()
    }
}

extension AddressListViewModelImpl {
    struct Output {
        let reload = PublishRelay<Void>()
    }
}
