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
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let containerView = UIView()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }

    public required init?(coder _: NSCoder) { nil }

    override public func prepareForReuse() {
        super.prepareForReuse()
    }

    func configure(brand: Brand) {
        guard let imageUrl = URL(string: brand.image) else { return }
        imageView.setImage(url: imageUrl)
        isUserInteractionEnabled = brand.isAvailable
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        configureShadow()
    }

    private func configureShadow() {
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: 16).cgPath

        contentView.clipsToBounds = false
    }

    private func layoutUI() {
        backgroundColor = .clear

        contentView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(4)
            $0.trailing.equalToSuperview().offset(-4)
            $0.bottom.equalToSuperview()
        }

        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true

        containerView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
