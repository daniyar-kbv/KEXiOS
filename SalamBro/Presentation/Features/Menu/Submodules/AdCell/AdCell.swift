//
//  AdCell.swift
//  SalamBro
//
//  Created by Arystan on 4/28/21.
//

import Reusable
import RxCocoa
import RxSwift
import UIKit

final class AdCell: UICollectionViewCell, NibReusable {
    private var viewModel: AdCellViewModelProtocol! {
        didSet { bind() }
    }

    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func set(_ viewModel: AdCellViewModelProtocol?) {
        self.viewModel = viewModel
    }

    private func bind() {}
}
