//
//  ReactiveExtension.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation
import RxSwift

extension Reactive where Base: UITableView {
    public var reload: Binder<Void?> {
        return Binder(self.base, binding: {
            guard let _ = $1 else { return }
            $0.reloadData()
        })
    }
}
