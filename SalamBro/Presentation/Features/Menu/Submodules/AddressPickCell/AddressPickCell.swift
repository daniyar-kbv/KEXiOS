//
//  AddressPickCell.swift
//  SalamBro
//
//  Created by Arystan on 4/27/21.
//

import Reusable
import RxCocoa
import RxSwift
import UIKit

final class AddressPickCell: UITableViewCell, NibReusable {
    @IBOutlet var changeButton: UIButton!
    @IBOutlet var deliverTitleLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!

    private var viewModel: AddressPickCellViewModelProtocol! {
        didSet { bind() }
    }

    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        changeButton.setTitle(L10n.AddressPickCell.changeButton, for: .normal)
        deliverTitleLabel.text = L10n.AddressPickCell.deliverLabel
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func set(_ viewModel: AddressPickCellViewModelProtocol?) {
        self.viewModel = viewModel
    }

    private func bind() {
        viewModel.address
            .bind(to: addressLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
