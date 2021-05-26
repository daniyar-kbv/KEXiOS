//
//  CategoryCell.swift
//  SalamBro
//
//  Created by Arystan on 4/27/21.
//

import Reusable
import RxCocoa
import RxSwift
import UIKit

final class CategoryCell: UICollectionViewCell, NibReusable {
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var selectView: UIView!

    private var viewModel: CategoryCellViewModelProtocol! {
        didSet { bind() }
    }

    private var disposeBag = DisposeBag()

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public var isSelected: Bool {
        didSet {
            selectView.isHidden = isSelected ? false : true
            categoryLabel.textColor = isSelected ? .black : .mildBlue
        }
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func set(_ viewModel: CategoryCellViewModelProtocol?) {
        self.viewModel = viewModel
    }

    private func bind() {
        viewModel.categoryTitle
            .bind(to: categoryLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
