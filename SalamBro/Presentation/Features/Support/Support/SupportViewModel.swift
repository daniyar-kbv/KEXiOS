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

    var documents: [Document] { get set }
    var contacts: [Contact] { get set }

    func getData()
    func fetchData()
    func getSocialContacts() -> [Contact]
    func getContact(of type: Contact.`Type`) -> Contact?
}

final class SupportViewModelImpl: SupportViewModel {
    private let disposeBag = DisposeBag()
    private let documentsRepository: DocumentsRepository

    let outputs = Output()

    var documents = [Document]()
    var contacts = [Contact]()

    init(documentsRepository: DocumentsRepository) {
        self.documentsRepository = documentsRepository

        bindDocumentsRepository()
    }

    func getData() {
        documentsRepository.getDocuments()
    }

    func fetchData() {
        documentsRepository.fetchDocuments { [weak self] documents, contacts in
            self?.process(documents: documents, contacts: contacts)
        }
    }

    func getSocialContacts() -> [Contact] {
        return contacts.filter { $0.getType() != .callCenter }
    }

    func getContact(of type: Contact.`Type`) -> Contact? {
        return contacts.first(where: { $0.getType() == type })
    }

    private func bindDocumentsRepository() {
        documentsRepository.outputs.didStartRequest
            .bind(to: outputs.didStartReqest)
            .disposed(by: disposeBag)

        documentsRepository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        documentsRepository.outputs.didGetError
            .bind(to: outputs.didGetError)
            .disposed(by: disposeBag)

        documentsRepository.outputs.didGetDocuments
            .subscribe(onNext: { [weak self] documents, contacts in
                self?.process(documents: documents, contacts: contacts)
            }).disposed(by: disposeBag)
    }

    private func process(documents: [Document], contacts: [Contact]) {
        self.documents = documents
        self.contacts = contacts
        outputs.update.accept(())
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
