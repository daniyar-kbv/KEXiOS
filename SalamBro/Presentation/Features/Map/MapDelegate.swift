//
//  MapDelegate.swift
//  SalamBro
//
//  Created by Arystan on 4/12/21.
//

import Foundation


protocol MapDelegate {
    func reverseGeocoding(searchQuery: String, title: String)
    func mapShadow(toggle: Bool)
    func showCommentarySheet()
    func hideCommentarySheet()
    func passCommentary(text: String)
    func dissmissView(viewName: String)
}
