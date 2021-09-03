//
//  SBTextButton.swift
//  SalamBro
//
//  Created by Dan on 8/24/21.
//

import Foundation
import UIKit

class SBTextButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {
        setTitleColor(.kexRed, for: .normal)
        setTitleColor(.darkRed, for: .highlighted)
        setTitleColor(.calmGray, for: .disabled)
    }
}
