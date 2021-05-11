//
//  BottomSheetViewController.swift
//  yandex-map
//
//  Created by Arystan on 3/31/21.
//

import UIKit

class AddressSheetController: ViewController {
    @IBOutlet var addressView: UIView!
    @IBOutlet var addressField: UITextField!
    @IBOutlet var proceedButton: UIButton!
    @IBOutlet var commentaryView: UIView!
    @IBOutlet var commentaryLabel: UILabel!

    weak var suggestVC: SuggestController?
    var yCoordinate: CGFloat?
    weak var delegate: MapDelegate?
    private var address: Address?
    private let geoRepository = DIResolver.resolve(GeoRepository.self)!

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
            let yComponent = UIScreen.main.bounds.height - 211 - 16
            self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func setupViews() {
        addressField.placeholder = L10n.MapView.AddressField.title
        commentaryLabel.text = L10n.MapView.CommentaryLabel.title
        proceedButton.setTitle(L10n.MapView.ProceedButton.title, for: .normal)
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        let tapAddress = UITapGestureRecognizer(target: self, action: #selector(didTapAddressView))
        addressView.addGestureRecognizer(tapAddress)
        let tapCommentary = UITapGestureRecognizer(target: self, action: #selector(didTapCommentaryView))
        commentaryView.addGestureRecognizer(tapCommentary)
    }

    @objc func didTapAddressView(sender _: UITapGestureRecognizer) {
        print("pick address button pressed")
        suggestVC!.modalPresentationStyle = .overCurrentContext
        present(suggestVC!, animated: true, completion: nil)
    }

    @objc func didTapCommentaryView(sender _: UITapGestureRecognizer) {
        delegate?.showCommentarySheet()
    }

    @IBAction func proceedAction(_: UIButton) {
        if let address = address {
            geoRepository.addresses?.append(address)
            geoRepository.currentAddress = address
        }
        delegate?.dissmissView()
    }
}

extension AddressSheetController {
    func changeAddress(address: String, longitude: Double, latitude: Double) {
        self.address = .init(name: address,
                             longitude: longitude,
                             latitude: latitude)
        if addressField != nil {
            addressField.text = "\(address)"
            if address != "" {
                proceedButton.backgroundColor = .kexRed
                proceedButton.isEnabled = true
            } else {
                proceedButton.backgroundColor = .calmGray
                proceedButton.isEnabled = false
            }
        }
    }

    func changeComment(comment: String) {
        if commentaryLabel != nil {
            commentaryLabel.text = "\(comment)"
            commentaryLabel.textColor = .black
            if comment == "" {
                commentaryLabel.text = L10n.MapView.CommentaryLabel.title
                commentaryLabel.textColor = .calmGray
            }
        }
    }
}
