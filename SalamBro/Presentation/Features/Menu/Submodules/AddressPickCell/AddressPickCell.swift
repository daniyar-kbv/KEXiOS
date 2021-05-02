//
//  AddressPickCell.swift
//  SalamBro
//
//  Created by Arystan on 4/27/21.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

public final class AddressPickCell: UITableViewCell, NibReusable {
    private var viewModel: AddressPickCellViewModelProtocol! {
        didSet { bind() }
    }
    private var disposeBag = DisposeBag()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
 
    public func set(_ viewModel: AddressPickCellViewModelProtocol?) {
        self.viewModel = viewModel
    }
    
    private func bind() {}
}
