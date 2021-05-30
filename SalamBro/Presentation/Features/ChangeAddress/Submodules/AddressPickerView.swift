//
//  AddressPickerView.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 20.05.2021.
//

import UIKit

final class AddressPickerView: UIView {
    var selectedItem: ((String) -> Void)?

    let textField: UITextField = {
        let tf = UITextField()
        tf.textColor = .darkGray
        return tf
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mildBlue
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()

    private let pickerView: SMPickerView
    private let dropDownImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "drop_down_icon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    init(placeholder: String, title: String?, values: [String]) {
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                             attributes: [.foregroundColor: UIColor.mildBlue, .font: UIFont.systemFont(ofSize: 16, weight: .medium)])
        titleLabel.text = title
        pickerView = SMPickerView(values: values)
        super.init(frame: .zero)
        pickerView.pickerDelegate = self
        textField.inputView = pickerView
        textField.inputAccessoryView = pickerView.toolBar
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        backgroundColor = UIColor(named: "surface_color")
        addSubview(dropDownImageView)
        dropDownImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }

        addSubview(textField)
        textField.snp.makeConstraints {
            $0.top.bottom.left.equalToSuperview()
//            $0.left.equalTo(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}

extension AddressPickerView: SMPickerViewDelegate {
    func didTapDone(_: SMPickerView, selected _: String) {
//        floatTextField.textField.text = item
//        floatTextField.textField.resignFirstResponder()
//        selectedItem?(item)
    }

    func didTapClose(_: SMPickerView) {
//        floatTextField.textField.resignFirstResponder()
    }
}
