//
//  MenuController.swift
//  SalamBro
//
//  Created by Arystan on 4/27/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Reusable

public final class MenuController: UIViewController {
    private let viewModel: MenuViewModelProtocol
    private let disposeBag: DisposeBag
    
    private lazy var logoView: UIImageView = {
        let view = UIImageView()
        view.image = Asset.Brands.salamBro4.image
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var brandLabel: UILabel = {
        let view = UILabel()
        view.text = "SalamBro"
        view.font = UIFont.boldSystemFont(ofSize: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var brandSelectView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var itemTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(cellType: AddressPickCell.self)
        view.register(cellType: MenuCell.self)
        view.register(cellType: AdCollectionCell.self)
        view.register(headerFooterViewType: CategoriesSectionHeader.self)
        view.delegate = self
        view.dataSource = self
        view.showsVerticalScrollIndicator = false
        view.estimatedRowHeight = 300
        view.bounces = false
        view.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        return view
    }()
    
    public init(viewModel: MenuViewModelProtocol) {
        self.viewModel = viewModel
        self.disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func bind() {
        viewModel.updateTableView
            .bind(to: itemTableView.rx.reload)
            .disposed(by: disposeBag)
    }
    
    private func setup() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        [logoView, brandLabel].forEach { brandSelectView.addSubview($0) }
        [brandSelectView, itemTableView].forEach { view.addSubview($0) }
    }
    
    func setupConstraints() {
        logoView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 48, height: 48))
            $0.top.left.equalToSuperview()
        }
        
        brandLabel.snp.makeConstraints {
            $0.left.equalTo(logoView.snp.right).offset(8)
            $0.centerY.equalTo(logoView.snp.centerY)
        }
        
        brandSelectView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).offset(8)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(48)
        }
        
        itemTableView.snp.makeConstraints {
            $0.top.equalTo(brandSelectView.snp.bottom).offset(8)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottomMargin)
        }
    }
}

extension MenuController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch viewModel.headerViewModels[section] {
        case is CategoriesSectionHeaderViewModelProtocol:
            return 44
        default:
            return 0
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.cellViewModels.count
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewModel.headerViewModels[section] {
        case let viewModel as CategoriesSectionHeaderViewModelProtocol:
            let header = tableView.dequeueReusableHeaderFooterView(CategoriesSectionHeader.self)
            header?.set(viewModel)
            return header
        default:
            return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellViewModels[section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.cellViewModels[indexPath.section][indexPath.row] {
        case let viewModel as AddressPickCellViewModelProtocol:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: AddressPickCell.self)
            cell.set(viewModel)
            return cell
        case let viewModel as AdCollectionCellViewModelProtocol:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: AdCollectionCell.self)
            cell.set(viewModel)
            return cell
        case let viewModel as MenuCellViewModelProtocol:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MenuCell.self)
            cell.set(viewModel)
            return cell
        default:
            return .init()
        }
    }
}
