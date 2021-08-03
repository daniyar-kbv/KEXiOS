//
//  BrandCell.swift
//  SalamBro
//
//  Created by Arystan on 4/7/21.
//

import Imaginary
import Reusable
import UIKit

final class BrandCell: UICollectionViewCell, Reusable {
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        return view
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)

        layoutUI()
    }

    public required init?(coder _: NSCoder) { nil }

    func configure(brand: Brand) {
        guard let imageUrl = URL(string: brand.image) else { return }
        imageView.setImage(url: imageUrl)
        isUserInteractionEnabled = brand.isAvailable ?? false
    }

    private func layoutUI() {
        backgroundColor = .clear

        contentView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }

        containerView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
