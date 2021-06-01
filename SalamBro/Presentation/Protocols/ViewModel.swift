//
//  ViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation
import SVProgressHUD

protocol ViewModel: AnyObject {
//    var router: Router { get }
//    func close()
    func startAnimation()
    func stopAnimation()
}

extension ViewModel {
//    func close() {
//        router.dismiss()
//    }

    func startAnimation() {
        SVProgressHUD.show()
    }

    func stopAnimation() {
        SVProgressHUD.dismiss()
    }
}
