//
//  PromotionsWebView.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 8/24/21.
//

import UIKit
import WebKit

class PromotionsWebView: WKWebView {
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
