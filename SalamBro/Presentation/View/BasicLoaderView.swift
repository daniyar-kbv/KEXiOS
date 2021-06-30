//
//  BasicLoaderView.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 30.06.2021.
//

import SVProgressHUD
import UIKit

final class BasicLoaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        backgroundColor = .clear
    }

    func showLoader() {
        SVProgressHUD.show()
    }

    func hideLoader() {
        SVProgressHUD.dismiss()
    }
}
