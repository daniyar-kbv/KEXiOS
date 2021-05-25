//
//  SMPickerView.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 20.05.2021.
//

import UIKit

protocol SMPickerViewDelegate: AnyObject {
    func didTapDone(_ view: SMPickerView, selected item: String)
    func didTapClose(_ view: SMPickerView)
}

final class SMPickerView: UIPickerView {
    weak var pickerDelegate: SMPickerViewDelegate?

    let toolBar = UIToolbar()

    private var selectedItem: String?

    private let values: [String]

    init(values: [String]) {
        self.values = values
        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        dataSource = self
        delegate = self
        showsSelectionIndicator = true

        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .kexRed
        toolBar.sizeToFit()

//        let doneButton = UIBarButtonItem(title: KIFResource.localized(key: "done"), style: .plain, target: self, action: #selector(handleDoneButtonAction))
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: KIFResource.localized(key: "cancel"), style: .plain, target: self, action: #selector(handleCancelButtonAction))

//        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }

    @objc private func handleDoneButtonAction(_: UIBarButtonItem) {
        guard let selectedItem = selectedItem else {
            pickerDelegate?.didTapDone(self, selected: values[0])
            return
        }

        pickerDelegate?.didTapDone(self, selected: selectedItem)
    }

    @objc private func handleCancelButtonAction(_: UIBarButtonItem) {
        pickerDelegate?.didTapClose(self)
    }
}

extension SMPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return values.count
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        return values[row]
    }

    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        selectedItem = values[row]
    }
}
