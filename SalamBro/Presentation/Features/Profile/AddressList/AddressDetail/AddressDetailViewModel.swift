//
//  AddressDetailViewModel.swift
//  SalamBro
//
//  Created by Dan on 7/1/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol AddressDetailViewModel {
    var outputs: AddressDetailViewModelImpl.Output { get }

    func delete()
}

final class AddressDetailViewModelImpl: AddressDetailViewModel {
    private let disposeBag = DisposeBag()
    private let userAddress: UserAddress
    private let addressRepository: AddressRepository

    let outputs: Output

    init(userAddress: UserAddress,
         addressRepository: AddressRepository)
    {
        self.userAddress = userAddress
        self.addressRepository = addressRepository

        outputs = .init(userAddress: userAddress,
                        addressRepository: addressRepository)
        bindAddressRepository()
    }

    private func bindAddressRepository() {
        addressRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        addressRepository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        addressRepository.outputs.didFail
            .bind(to: outputs.didGetError)
            .disposed(by: disposeBag)

        addressRepository.outputs.didDeleteUserAddress
            .bind(to: outputs.didDelete)
            .disposed(by: disposeBag)
    }

    func delete() {
        guard let id = userAddress.id else { return }
        addressRepository.deleteUserAddress(with: id)
    }
}

extension AddressDetailViewModelImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable>()

        let addressName: BehaviorRelay<String?>
        let comment: BehaviorRelay<String?>
        let isCurrent: BehaviorRelay<Bool>

        let didDelete = PublishRelay<Void>()

        init(userAddress: UserAddress,
             addressRepository: AddressRepository)
        {
            addressName = .init(value: userAddress.address.getName())
            comment = .init(value: userAddress.address.comment)
            isCurrent = .init(value: userAddress == addressRepository.getCurrentUserAddress())
        }
    }
}
