//
//  DocumentsRepository.swift
//  SalamBro
//
//  Created by Dan on 7/5/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol DocumentsRepository: AnyObject {
    var outputs: DocumentsRepositoryImpl.Output { get }

    func getDocuments()
    func getUserAgreement()
    func fetchDocuments(completion: @escaping (_: [Document], _: [Contact]) -> Void)
}

final class DocumentsRepositoryImpl: DocumentsRepository {
    private let storage: DocumentsStorage
    private let service: DocumentsService

    private let disposeBag = DisposeBag()
    private var needsFetchDocuments = true

    private let userAgreementSlug = "publichnaya-oferta"

    let outputs = Output()

    init(storage: DocumentsStorage, service: DocumentsService) {
        self.storage = storage
        self.service = service
    }

    func getDocuments() {
        guard needsFetchDocuments else {
            outputs.didGetDocuments.accept((storage.documents, storage.contacts))
            return
        }

        fetchDocuments { [weak self] documents, contacts in
            self?.outputs.didGetDocuments.accept((documents, contacts))
        }
    }

    func getUserAgreement() {
        guard !needsFetchDocuments,
              let userAgreement = storage.documents.first(where: { $0.slug == userAgreementSlug })
        else {
            fetchDocuments { [weak self] documents, _ in
                guard let userAgreement = documents.first(where: { $0.slug == self?.userAgreementSlug }) else { return }
                self?.outputs.didGetUserAgreement.accept(userAgreement)
            }

            return
        }

        outputs.didGetUserAgreement.accept(userAgreement)
    }

    func fetchDocuments(completion: @escaping (_: [Document], _: [Contact]) -> Void) {
        let sequence = Single.zip(service.getDocuments(),
                                  service.getContacts())

        outputs.didStartRequest.accept(())
        sequence.subscribe(onSuccess: { [weak self] documents, contacts in
            self?.outputs.didEndRequest.accept(())
            self?.process(documents: documents, contacts: contacts)
            completion(documents, contacts)
        }, onError: { [weak self] error in
            self?.outputs.didEndRequest.accept(())
            guard let error = error as? ErrorPresentable else { return }
            self?.outputs.didGetError.accept(error)
        }).disposed(by: disposeBag)
    }

    private func process(documents: [Document],
                         contacts: [Contact])
    {
        storage.documents = documents
        storage.contacts = contacts
        needsFetchDocuments = false
    }
}

extension DocumentsRepositoryImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable>()
        let didGetDocuments = PublishRelay<([Document], [Contact])>()
        let didGetUserAgreement = PublishRelay<Document>()
    }
}
