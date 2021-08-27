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

    lazy var notAvaliableView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        return view
    }()

    lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0.8
        return view
    }()

    lazy var notAvalilableLabel: UILabel = {
        let view = UILabel()
        view.text = "Coming\nsoon"
        view.font = SBFontResource.getFont(for: SBFonts.Pattaya.regular, with: 20)
        view.textColor = .darkGray
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)

        layoutUI()
    }

    public required init?(coder _: NSCoder) { nil }

    func configure(brand: Brand) {
        guard let status = brand.isAvailable else { return }
        configure(imageURLStr: brand.image)
        configure(isAvailable: status)
    }

    private func configure(imageURLStr: String) {
        guard let imageUrl = URL(string: imageURLStr) else { return }
        imageView.setImage(url: imageUrl)
    }

    private func configure(isAvailable: Bool) {
        notAvaliableView.isHidden = isAvailable
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

        imageView.addSubview(notAvaliableView)
        notAvaliableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        [blurView, notAvalilableLabel].forEach { notAvaliableView.addSubview($0) }

        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        notAvalilableLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
