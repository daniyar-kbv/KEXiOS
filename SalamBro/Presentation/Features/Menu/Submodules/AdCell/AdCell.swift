//
//  AdCell.swift
//  SalamBro
//
//  Created by Arystan on 4/28/21.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

public final class AdCell: UICollectionViewCell, NibReusable {
    private var viewModel: AdCellViewModelProtocol! {
        didSet { bind() }
    }
    private var disposeBag = DisposeBag()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    public func set(_ viewModel: AdCellViewModelProtocol?) {
        self.viewModel = viewModel
    }
    
    private func bind() {}
}
