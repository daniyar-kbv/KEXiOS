//
//  BottomSheetViewController.swift
//  yandex-map
//
//  Created by Arystan on 3/31/21.
//

import UIKit

class AddressSheetController: UIViewController {
    
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var commentaryField: UITextField!
    @IBOutlet weak var proceedButton: UIButton!
    
    var suggestVC: SuggestController?
    var yCoordinate: CGFloat?
    var delegate: MapDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentaryField.allowsEditingTextAttributes = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) { [weak self] in
            let frame = self?.view.frame
            let yComponent = UIScreen.main.bounds.height - 211
            self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
        }
    }

    @IBAction func didBeginEditingCommentary(_ sender: UITextField) {
        delegate?.showCommentarySheet()
    }
    
    
    @IBAction func proceedAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(MainTabController(), animated: true)
    }
    
    @IBAction func pickAddressAction(_ sender: UIButton) {
//        view.removeFromSuperview()
//        removeFromParent()
        suggestVC!.modalPresentationStyle = .overCurrentContext
//        navigationController?.pushViewController(suggestVC!, animated: true)
        present(suggestVC!, animated: true, completion: nil)
//        view.removeFromSuperview()
//        removeFromParent()
    }
}

extension AddressSheetController {
    func pointTapped(address: String) {
        addressField.text = "\(address)"
    }
}
