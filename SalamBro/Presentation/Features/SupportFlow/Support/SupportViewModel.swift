//
//  SupportViewModel.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 18.06.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol SupportViewModel: AnyObject {
    var outputs: SupportViewModelImpl.Output { get }

    var documents: [Document]? { get set }
    var contacts: [Contact]? { get set }

    func getData()
    func getSocialContacts() -> [Contact]
    func getContact(of type: Contact.`Type`) -> Contact?
}

final class SupportViewModelImpl: SupportViewModel {
    private let disposeBag = DisposeBag()
    private let documentsService: DocumentsService

    let outputs = Output()

    var documents: [Document]?
    var contacts: [Contact]?

    init(documentsService: DocumentsService) {
        self.documentsService = documentsService
    }

    func getData() {
        let sequence = Single.zip(documentsService.getDocuments(),
                                  documentsService.getContacts())

        outputs.didStartReqest.accept(())
        sequence.subscribe(onSuccess: { [weak self] documents, contacts in
            self?.outputs.didEndRequest.accept(())
            self?.documents = documents
            self?.contacts = contacts
            self?.appendContacts()
            self?.outputs.update.accept(())
        }, onError: { [weak self] error in
            guard let error = error as? ErrorPresentable else { return }
            self?.outputs.didEndRequest.accept(())
            self?.outputs.didGetError.accept(error)
        }).disposed(by: disposeBag)
    }

//    MARK: Mock data for testing

//    Tech debt: remove when social contacts returned from api
    private func appendContacts() {
        let socialContacts = ([.instagram, .tiktok, .email, .vk] as [Contact.`Type`])
            .map { type -> Contact in
                switch type {
                case .instagram, .tiktok:
                    return Contact(name: type.rawValue, value: "sultan.amanbai")
                case .email:
                    return Contact(name: type.rawValue, value: "usembaevsultan08@gmail.com")
                case .vk:
                    return Contact(name: type.rawValue, value: "https://vk.com/sultan01cool")
                default:
                    return Contact(name: type.rawValue, value: "sultan.amanbai")
                }
            }

        contacts?.append(contentsOf: socialContacts)
    }

    func getSocialContacts() -> [Contact] {
        return contacts?.filter { $0.getType() != .callCenter } ?? []
    }

    func getContact(of type: Contact.`Type`) -> Contact? {
        return contacts?.first(where: { $0.getType() == type })
    }
}

extension SupportViewModelImpl {
    struct Output {
        let didStartReqest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable>()

        let update = PublishRelay<Void>()
    }
}
