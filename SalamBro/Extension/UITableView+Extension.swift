//
//  UITableView+Extension.swift
//  SalamBro
//
//  Created by Arystan on 5/9/21.
//

import SnapKit
import UIKit
extension UITableView {
    func addTableHeaderViewLine() {
        tableHeaderView = {
            let line = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1 / UIScreen.main.scale))
            let separator = SeparatorView()
            line.addSubview(separator)
            separator.snp.makeConstraints {
                $0.left.equalToSuperview().offset(24)
                $0.right.equalTo(-24)
                $0.bottom.equalToSuperview()
                $0.height.equalTo(0.3)
            }
            return line
        }()
    }
}
