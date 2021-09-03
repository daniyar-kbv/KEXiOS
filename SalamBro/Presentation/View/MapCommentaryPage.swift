//
//  MapCommentaryPage.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 04.06.2021.
//

import RxCocoa
import RxSwift
import UIKit

// Tech debt: add types

final class MapCommentaryPage: UIViewController {
    var cachedCommentary: String? {
        didSet {
            commentaryTextField.set(text: cachedCommentary)
        }
    }

    private let disposeBag = DisposeBag()
    let output = Output()

    private let commentaryTextField = MapTextField(image: nil)
    private let actionButton: SBSubmitButton = {
        let btn = SBSubmitButton(style: .filledRed)
        btn.isEnabled = false
        btn.setTitle(SBLocalization.localized(key: CommentaryText.buttonTitle), for: .normal)
        return btn
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 18
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return view
    }()

    init() {
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .overCurrentContext

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        commentaryTextField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        view.backgroundColor = .clear
    }

    private func bindViews() {
        commentaryTextField.rx.text.orEmpty
            .subscribe(onNext: { [weak self] text in
                self?.actionButton.isEnabled = !text.isEmpty
            })
            .disposed(by: disposeBag)

        actionButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.output.didProceed.accept(self?.commentaryTextField.getText())
                self?.finish()
            })
            .disposed(by: disposeBag)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            containerView.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(-keyboardSize.height)
            }

            UIView.animate(withDuration: 0.2, animations: {
                self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
                self.view.layoutIfNeeded()
            })
        }
    }

    @objc private func keyboardWillHide() {
        close()
    }

    public func configureTextField(placeholder: String) {
        commentaryTextField.placeholder = placeholder
    }

    public func configureTextField(autocapitalizationType: UITextAutocapitalizationType) {
        commentaryTextField.autocapitalizationType = autocapitalizationType
    }

    public func configureButton(title: String) {
        actionButton.setTitle(title, for: .normal)
    }

    private func layoutUI() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview().offset(300)
        }

        containerView.addSubview(commentaryTextField)
        commentaryTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.greaterThanOrEqualTo(50)
        }

        containerView.addSubview(actionButton)
        actionButton.snp.makeConstraints {
            $0.top.equalTo(commentaryTextField.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(43)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
}

extension MapCommentaryPage {
    func openTransitionSheet(on vc: UIViewController,
                             with comment: String? = nil)
    {
        cachedCommentary = comment

        vc.present(self, animated: false)
    }

    private func finish() {
        commentaryTextField.resignFirstResponder()
    }

    private func close() {
        containerView.snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(300)
        }

        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
            self.view.backgroundColor = .clear
        }, completion: { _ in
            self.dismiss(animated: false)
        })
    }
}

extension MapCommentaryPage {
    struct Output {
        let didProceed = PublishRelay<String?>()
    }
}
