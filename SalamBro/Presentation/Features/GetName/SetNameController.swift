//
//  GetNameController.swift
//  SalamBro
//
//  Created by Arystan on 3/10/21.
//

import UIKit

final class SetNameController: ViewController {
    var didGetEnteredName: ((String) -> Void)?

    fileprivate lazy var rootView = SetNameView(delegate: self)

    override func loadView() {
        view = rootView
    }
}

extension SetNameController: GetNameViewDelegate {
    func submit(name: String) {
        didGetEnteredName?(name)
    }
}
