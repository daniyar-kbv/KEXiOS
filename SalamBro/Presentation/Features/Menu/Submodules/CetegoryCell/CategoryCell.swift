//
//  CategoryCell.swift
//  SalamBro
//
//  Created by Arystan on 4/27/21.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

public final class CategoryCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var selectView: UIView!
    
    private var viewModel: CategoryCellViewModelProtocol! {
        didSet { bind() }
    }
    private var disposeBag = DisposeBag()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public override var isSelected: Bool {
        didSet {
            selectView.isHidden = isSelected ? false : true
            categoryLabel.textColor = isSelected ? .black : .mildBlue
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    public func set(_ viewModel: CategoryCellViewModelProtocol?) {
        self.viewModel = viewModel
    }
    
    private func bind() {
        viewModel.categoryTitle
            .bind(to: categoryLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
