//
//  BottomSheetViewController.swift
//  yandex-map
//
//  Created by Arystan on 3/31/21.
//

import UIKit

class AddressSheetController: UIViewController {
    
    @IBOutlet weak var addressField: UITextField!
    
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var commentaryLabel: UILabel!
    
    var suggestVC: SuggestController?
    var yCoordinate: CGFloat?
    var delegate: MapDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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
    
    func setupViews() {
        addressField.placeholder = L10n.MapView.AddressField.title
        commentaryLabel.text = L10n.MapView.CommentaryLabel.title
        proceedButton.setTitle(L10n.MapView.ProceedButton.title, for: .normal)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCommentaryLabel))
        commentaryLabel.addGestureRecognizer(tap)
    }
    
    @objc func didTapCommentaryLabel(sender: UITapGestureRecognizer) {
        delegate?.showCommentarySheet()
    }

    @IBAction func proceedAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(MainTabController(), animated: true)
    }
    
    @IBAction func pickAddressAction(_ sender: UIButton) {
        suggestVC!.modalPresentationStyle = .overCurrentContext
        present(suggestVC!, animated: true, completion: nil)
    }
}

extension AddressSheetController {
    func changeAddress(address: String) {
        addressField.text = "\(address)"
        if addressField.text != nil {
            proceedButton.backgroundColor = .kexRed
            proceedButton.isEnabled = true
        }
    }
    
    func changeComment(comment: String) {
        commentaryLabel.text = "\(comment)"
        commentaryLabel.textColor = .black
        if commentaryLabel.text == "" {
            commentaryLabel.text = L10n.MapView.CommentaryLabel.title
            commentaryLabel.textColor = .calmGray
        }
        
    }
}
