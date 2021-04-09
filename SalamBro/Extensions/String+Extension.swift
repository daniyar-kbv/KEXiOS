//
//  String+Extension.swift
//  SalamBro
//
//  Created by Arystan on 3/13/21.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
