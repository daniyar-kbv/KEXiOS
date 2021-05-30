//
//  GetNameController.swift
//  SalamBro
//
//  Created by Arystan on 3/10/21.
//

import UIKit

final class SetNameController: ViewController {
    var didGetEnteredName: ((String) -> Void)?

    private lazy var rootView = SetNameView(delegate: self)
    private let viewModel: SetNameViewModel

    init(viewModel: SetNameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = rootView
    }
}

extension SetNameController: GetNameViewDelegate {
    func submit(name: String) {
        viewModel.persist(name: name)
        didGetEnteredName?(name)
    }
}
