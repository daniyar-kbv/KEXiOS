//
//  CommentarySheetController.swift
//  yandex-map
//
//  Created by Arystan on 4/10/21.
//

import UIKit

class CommentarySheetController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var commentaryField: UITextField!
    @IBOutlet weak var proceedButton: UIButton!
    
    var delegate: MapDelegate?
    var yCoordinate: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        yCoordinate = self.view.frame.origin.y
        delegate?.mapShadow(toggle: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.mapShadow(toggle: false)
    }
    
    func setupViews() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = yCoordinate!
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        if commentaryField.text != nil {
//            self.dismiss(animated: true) {
                self.removeFromParent()
                self.view.removeFromSuperview()
                self.delegate?.passCommentary(text: self.commentaryField.text!)
                self.delegate?.hideCommentarySheet()
//            }
        }
    }
}
