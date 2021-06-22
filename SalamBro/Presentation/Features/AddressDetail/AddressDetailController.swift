//
//  AddressDetailController.swift
//  SalamBro
//
//  Created by Arystan on 5/7/21.
//

import RxCocoa
import RxSwift
import UIKit

final class AddressDetailController: UIViewController {
    let outputs = Output()
    private let locationRepository: LocationRepository
    private let deliveryAddress: DeliveryAddress

    private lazy var deleteButton: UIButton = {
        let view = UIButton()
        view.tintColor = .kexRed
        view.setImage(UIImage(named: "trash"), for: .normal)
        view.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        return view
    }()

    private var contentView = AddressDetailView()

    init(deliveryAddress: DeliveryAddress,
         locationRepository: LocationRepository)
    {
        self.deliveryAddress = deliveryAddress
        self.locationRepository = locationRepository

        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.shadowImage = .init()
        navigationController?.navigationBar.setBackgroundImage(.init(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .kexRed
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor: UIColor.black,
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "chevron.left"), style: .plain, target: self, action: #selector(dismissVC))
        navigationItem.title = L10n.AddressPicker.titleOne
        navigationItem.rightBarButtonItem = .init(customView: deleteButton)
    }
}

extension AddressDetailController {
    private func configureViews() {
        if let deliveryAddressName = deliveryAddress.address?.name, let commentary = deliveryAddress.address?.commentary {
            contentView.configure(name: deliveryAddressName, commentary: commentary)
        }
    }

    private func layoutUI() {
        view.backgroundColor = .white

        view.addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

extension AddressDetailController {
    @objc private func dismissVC() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func deleteAction() {
//        Tech debt add localization
        let alert = UIAlertController(title: "Вы уверены?", message: "Вы уверены что хотите удалить адрес доставки?", preferredStyle: .alert)
        alert.view.tintColor = .kexRed
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] _ in
            guard let deliveryAddress = self?.deliveryAddress else { return }
            self?.locationRepository.deleteDeliveryAddress(deliveryAddress: deliveryAddress)
            self?.outputs.didDeleteAddress.accept(())
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default))
        present(alert, animated: true, completion: nil)
    }
}

extension AddressDetailController {
    struct Output {
        let didDeleteAddress = PublishRelay<Void>()
    }
}
