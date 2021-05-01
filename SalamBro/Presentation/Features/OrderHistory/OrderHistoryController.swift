//
//  OrderHistoryController.swift
//  SalamBro
//
//  Created by Arystan on 3/25/21.
//

import UIKit
import WebKit

class OrderHistoryController: UIViewController {

    fileprivate lazy var rootView = OrderHistoryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func loadView() {
        view = rootView
    }
    
    func setupUI() {
        navigationController?.title = "Order history"
        rootView.shareToInstagramButton.addTarget(self, action: #selector(shareToInstagramAction), for: .touchUpInside)
        rootView.rateOrderButton.addTarget(self, action: #selector(rateOrderAction), for: .touchUpInside)
    }
    
    @objc func shareToInstagramAction() {
        navigationController?.pushViewController(ShareOrderController(), animated: true)
    }
    
    @objc func rateOrderAction() {
        navigationController?.pushViewController(RateController(), animated: true)
    }
}
