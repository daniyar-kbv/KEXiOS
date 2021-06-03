//
//  MenuScrollService.swift
//  SalamBro
//
//  Created by Dan on 6/3/21.
//

import Foundation
import RxCocoa
import RxSwift

class MenuScrollService {
    private var disposeBag = DisposeBag()
    
    lazy var didSelectCategory = PublishRelay<(source: Source, position: Int)>()
    
    var currentCategoryPosition: Int = 0
    var isHeaderScrolling: Bool = false
    
    init() {
        bind()
    }
    
    func bind() {
        didSelectCategory.subscribe(onNext: { [weak self] in
            self?.currentCategoryPosition = $1
        }).disposed(by: disposeBag)
    }
    
    func startedScrolling() {
        isHeaderScrolling = true
    }
    
    func finishedScrolling() {
        isHeaderScrolling = false
    }
    
    enum Source {
        case header
        case table
    }
}
