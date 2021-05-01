//
//  ShareOrderController.swift
//  SalamBro
//
//  Created by Arystan on 4/22/21.
//

import UIKit
import WebKit

class ShareOrderController: UIViewController {
    
    fileprivate lazy var rootView = ShareOrderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func loadView() {
        view = rootView
    }
    
    func setupUI() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "post", style: .done, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped() {
        let url = URL(string: "instagram-stories://share")!
        if UIApplication.shared.canOpenURL(url){
            let backgroundData = self.view.asImage().jpegData(compressionQuality: 1.0)!
            let pasteBoardItems = [
                                    ["com.instagram.sharedSticker.backgroundImage" : backgroundData]
                                  ]

            if #available(iOS 10.0, *) {

                UIPasteboard.general.setItems(pasteBoardItems, options: [.expirationDate: Date().addingTimeInterval(60 * 5)])
            } else {
                UIPasteboard.general.items = pasteBoardItems
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
