//
//  DocumentsService.swift
//  SalamBro
//
//  Created by Dan on 6/24/21.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

protocol DocumentsService: AnyObject {
    func getDocuments() -> Single<[Document]>
    func getContacts() -> Single<[Contact]>
}

final class DocumentsServiceImpl: DocumentsService {
    private let disposeBag = DisposeBag()

    private let provider: MoyaProvider<DocumentsAPI>

    init(provider: MoyaProvider<DocumentsAPI>) {
        self.provider = provider
    }

    func getDocuments() -> Single<[Document]> {
        return provider.rx
            .request(.documents)
            .retryWhenDeliveryChanged()
            .map { response in
                guard
                    let documentsResponse = try? response.map(DocumentsResponse.self)
                else {
                    throw NetworkError.badMapping
                }

                if let error = documentsResponse.error {
                    throw error
                }

                guard let documents = documentsResponse.data else {
                    throw NetworkError.badMapping
                }

                return documents
            }
    }

    func getContacts() -> Single<[Contact]> {
        return provider.rx
            .request(.contacts)
            .retryWhenDeliveryChanged()
            .map { response in
                guard let contactsResponse = try? response.map(ContactsResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = contactsResponse.error {
                    throw error
                }

                guard let contacts = contactsResponse.data else {
                    throw NetworkError.badMapping
                }

                return contacts
            }
    }
}
