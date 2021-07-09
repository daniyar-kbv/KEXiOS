//
//  SupportSocialCell.swift
//  SalamBro
//
//  Created by Dan on 6/24/21.
//

import Foundation
import UIKit

class SupportSocialCell: UICollectionViewCell {
    var contact: Contact? {
        didSet {
            imageView.image = contact?.getType()?.image
        }
    }

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layoutUI() {
        contentView.addSubview(imageView)

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configure(with contact: Contact) {
        self.contact = contact
    }
}
