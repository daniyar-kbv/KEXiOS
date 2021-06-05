//
//  MapCommentaryPage.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 04.06.2021.
//

import RxCocoa
import RxSwift
import UIKit

protocol MapCommentaryPageDelegate: AnyObject {
    func onDoneButtonTapped(commentary: String)
}

final class MapCommentaryPage: UIViewController {
    weak var delegate: MapCommentaryPageDelegate?
    var cachedCommentary: String? {
        didSet {
            commentaryTextField.text = cachedCommentary
        }
    }

    private let disposeBag = DisposeBag()

    private let commentaryTextField = MapTextField(image: nil)
    private let actionButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .calmGray
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        return btn
    }()

    private let containerView = UIView()

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        bindViews()
    }

    private func bindViews() {
        commentaryTextField.rx.text.orEmpty
            .subscribe(onNext: { [weak self] text in
                if text != "" {
                    self?.actionButton.isEnabled = true
                    self?.actionButton.backgroundColor = .kexRed
                    return
                }

                self?.actionButton.isEnabled = false
                self?.actionButton.backgroundColor = .calmGray
            })
            .disposed(by: disposeBag)

        actionButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let text = self?.commentaryTextField.text else { return }
                self?.delegate?.onDoneButtonTapped(commentary: text)
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            containerView.snp.remakeConstraints {
                $0.height.greaterThanOrEqualTo(149)
                $0.width.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-keyboardSize.height)
            }
        }
    }

    @objc private func keyboardWillHide() {
        dismiss(animated: true, completion: nil)
    }

    private func layoutUI() {
        commentaryTextField.becomeFirstResponder()
        commentaryTextField.attributedPlaceholder = NSAttributedString(
            string: L10n.Commentary.AddressField.title,
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        )

        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 18
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        containerView.snp.makeConstraints {
            $0.height.equalTo(view.frame.height / 2 + 48)
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        actionButton.setTitle(L10n.Commentary.Button.title, for: .normal)

        view.backgroundColor = .clear

        containerView.addSubview(commentaryTextField)
        commentaryTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.greaterThanOrEqualTo(50)
        }

        containerView.addSubview(actionButton)
        actionButton.snp.makeConstraints {
            $0.top.equalTo(commentaryTextField.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(43)
        }
    }
}
