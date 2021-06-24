//
//  SupportController.swift
//  SalamBro
//
//  Created by Arystan on 3/18/21.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class SupportController: UIViewController, LoaderDisplayable, AlertDisplayable {
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorColor = .mildBlue
        view.addTableHeaderViewLine()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.estimatedRowHeight = 50
        view.tableFooterView = UIView()
        view.delegate = self
        view.dataSource = self
        view.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        view.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 186, right: 0)
        return view
    }()

    private lazy var socialCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(SupportSocialCell.self, forCellWithReuseIdentifier: String(describing: SupportSocialCell.self))
        view.isScrollEnabled = false
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        return view
    }()

    private lazy var callButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Support.callcenter, for: .normal)
        button.setTitleColor(.kexRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(call), for: .touchUpInside)
        button.borderWidth = 1
        button.borderColor = .kexRed
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()

    private let disposeBag = DisposeBag()
    private let viewModel: SupportViewModel

    let outputs = Output()

    init(viewModel: SupportViewModel) {
        self.viewModel = viewModel

        super.init(nibName: .none, bundle: .none)

        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        viewModel.getData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.shadowImage = .init()
        navigationController?.navigationBar.setBackgroundImage(.init(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor: UIColor.black,
        ]
        navigationItem.title = L10n.Support.title
    }

    private func bindViewModel() {
        viewModel.outputs.didStartReqest
            .subscribe(onNext: { [weak self] in
                self?.showLoader()
            }).disposed(by: disposeBag)

        viewModel.outputs.didEndRequest
            .subscribe(onNext: { [weak self] in
                self?.hideLoader()
            }).disposed(by: disposeBag)

        viewModel.outputs.didGetError
            .subscribe(onNext: { [weak self] error in
                self?.showError(error)
            }).disposed(by: disposeBag)

        viewModel.outputs.update
            .subscribe(onNext: { [weak self] in
                self?.update()
            }).disposed(by: disposeBag)
    }

    private func update() {
        tableView.reloadData()
        socialCollectionView.reloadData()
    }

    private func layoutUI() {
        view.backgroundColor = .white

        [tableView, socialCollectionView, callButton].forEach { view.addSubview($0) }

        tableView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        callButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            $0.height.equalTo(43)
        }

        socialCollectionView.snp.makeConstraints {
            $0.bottom.equalTo(callButton.snp.top).offset(-64)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(40)
        }
    }

    @objc private func call() {
        process(contact: viewModel.getContact(of: .callCenter))
    }

    private func process(contact: Contact?) {
        guard let url = contact?.getURL(),
              UIApplication.shared.canOpenURL(url) else { return }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

extension SupportController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let link = viewModel.documents?[indexPath.row].link,
              let url = URL(string: link) else { return }
        outputs.openDocument.accept(url)
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0, indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel?.text = viewModel.documents?[indexPath.row].name
            cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            cell.imageView?.image = UIImage(named: "documents")
            return cell
        }
        return UITableViewCell()
    }
}

extension SupportController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.getSocialContacts().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SupportSocialCell.self), for: indexPath) as! SupportSocialCell
        cell.configure(with: viewModel.getSocialContacts()[indexPath.item])
        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        process(contact: viewModel.getSocialContacts()[indexPath.item])
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 20
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        let totalCellWidth = 40 * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = 20 * (collectionView.numberOfItems(inSection: 0) - 1)

        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}

extension SupportController {
    struct Output {
        let openDocument = PublishRelay<URL>()
    }
}
