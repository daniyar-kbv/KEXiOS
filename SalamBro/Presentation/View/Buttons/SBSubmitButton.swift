//
//  SBSubmitButton.swift
//  SalamBro
//
//  Created by Dan on 8/24/21.
//

import Foundation
import UIKit

class SBSubmitButton: UIButton {
    private let style: Style

    override var isHighlighted: Bool {
        didSet {
            layer.borderColor = style
                .getBorderColor(for: isHighlighted ? .highlighted : .normal)?
                .cgColor
        }
    }

    override var isEnabled: Bool {
        didSet {
            layer.borderColor = style
                .getBorderColor(for: isEnabled ? .normal : .disabled)?
                .cgColor
        }
    }

    init(style: Style) {
        self.style = style

        super.init(frame: .zero)

        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SBSubmitButton {
    private func layoutUI() {
        setBackgroundColor(color: style.getBackroundColor(for: .normal),
                           forState: .normal)
        setBackgroundColor(color: style.getBackroundColor(for: .highlighted),
                           forState: .highlighted)
        setBackgroundColor(color: style.getBackroundColor(for: .disabled),
                           forState: .disabled)

        setTitleColor(style.getTitleColor(for: .normal), for: .normal)
        setTitleColor(style.getTitleColor(for: .highlighted), for: .highlighted)
        setTitleColor(style.getTitleColor(for: .disabled), for: .disabled)

        titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)

        layer.masksToBounds = true
        layer.cornerRadius = 10

        layer.borderWidth = style.borderWidth
        layer.borderColor = style.getBorderColor(for: .normal)?.cgColor
    }
}

extension SBSubmitButton {
    enum Style {
        case filledRed
        case emptyRed
        case emptyBlack
        case emptyGray
        case whiteGray

        var borderWidth: CGFloat {
            switch self {
            case .filledRed, .whiteGray: return 0
            case .emptyRed, .emptyBlack, .emptyGray: return 1
            }
        }

        func getBackroundColor(for state: UIControl.State) -> UIColor {
            switch state {
            case .normal:
                switch self {
                case .filledRed, .whiteGray: return .kexRed
                case .emptyRed, .emptyBlack, .emptyGray: return .clear
                }
            case .highlighted:
                switch self {
                case .filledRed, .emptyRed, .whiteGray: return .darkRed
                case .emptyBlack: return .darkGray
                case .emptyGray: return .mildBlue
                }
            case .disabled:
                switch self {
                case .filledRed: return .calmGray
                case .emptyRed, .emptyBlack, .emptyGray, .whiteGray: return .clear
                }
            default:
                return .clear
            }
        }

        func getTitleColor(for state: UIControl.State) -> UIColor {
            switch state {
            case .normal:
                switch self {
                case .filledRed, .whiteGray: return .arcticWhite
                case .emptyRed: return .kexRed
                case .emptyBlack: return .darkGray
                case .emptyGray: return .mildBlue
                }
            case .highlighted:
                return .arcticWhite
            case .disabled:
                switch self {
                case .filledRed: return .arcticWhite
                case .emptyRed, .emptyBlack, .emptyGray:
                    return getTitleColor(for: .normal).withAlphaComponent(0.5)
                case .whiteGray: return .mildBlue
                }
            default:
                return .clear
            }
        }

        func getBorderColor(for state: UIControl.State) -> UIColor? {
            switch state {
            case .normal, .highlighted:
                switch self {
                case .filledRed, .whiteGray: return nil
                case .emptyRed: return .kexRed
                case .emptyBlack: return .darkGray
                case .emptyGray: return .mildBlue
                }
            case .disabled:
                return getBorderColor(for: .normal)?.withAlphaComponent(0.5)
            default:
                return .clear
            }
        }
    }
}
