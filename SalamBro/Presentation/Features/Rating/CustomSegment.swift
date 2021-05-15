//
//  CustomSegment.swift
//  DetailView
//
//  Created by Arystan on 5/3/21.
//

import UIKit

protocol CustomSegmentedControlDelegate {
    func change(to index: Int)
}

class CustomSegmentedControl: UIView {
    private var buttonTitles: [String]!
    private var buttons: [UIButton]!

    var textColor: UIColor = .kexRed
    var selectorViewColor: UIColor = .kexRed
    var selectorTextColor: UIColor = .kexRed

    var delegate: CustomSegmentedControlDelegate?

    public private(set) var selectedIndex: Int = 0

    init(buttonTitle: [String]) {
        super.init(frame: .zero)
        buttonTitles = buttonTitle
        updateView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setIndex(index: Int) {
        buttons.forEach { $0.setTitleColor(textColor, for: .normal) }
        let button = buttons[index]
        selectedIndex = index
        button.setTitleColor(selectorTextColor, for: .normal)
        button.backgroundColor = selectorViewColor
    }

    @objc func buttonAction(sender: UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            btn.backgroundColor = .white
            if btn == sender {
                selectedIndex = buttonIndex
                btn.backgroundColor = selectorViewColor
                btn.setTitleColor(selectorTextColor, for: .normal)
                delegate?.change(to: selectedIndex)
            }
        }
    }
}

extension CustomSegmentedControl {
    private func updateView() {
        backgroundColor = UIColor.white
        createButton()
        configStackView()
    }

    private func configStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    private func createButton() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach { $0.removeFromSuperview() }
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.addTarget(self, action: #selector(CustomSegmentedControl.buttonAction(sender:)), for: .touchUpInside)
            button.backgroundColor = .white
            button.setTitleColor(textColor, for: .normal)
            buttons.append(button)
        }
    }
}
