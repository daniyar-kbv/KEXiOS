//
//  MenuTableswift
//  SalamBro
//
//  Created by Dan on 10/12/21.
//

import Foundation
import UIKit

final class MenuTableView: UITableView {
    var onUpdate: (() -> Void)?

    init() {
        super.init(frame: .zero, style: .plain)

        separatorColor = .mildBlue
        backgroundColor = .white
        register(cellType: AddressPickCell.self)
        register(cellType: MenuCell.self)
        register(cellType: AdCollectionCell.self)
        register(headerFooterViewType: CategoriesSectionHeader.self)
        showsVerticalScrollIndicator = false
        estimatedRowHeight = 300
        separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        tableFooterView = UIView()
        refreshControl = refreshControl
        delaysContentTouches = false
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(delegate: UITableViewDelegate & UITableViewDataSource) {
        self.delegate = delegate
        dataSource = delegate
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        onUpdate?()
    }
}
