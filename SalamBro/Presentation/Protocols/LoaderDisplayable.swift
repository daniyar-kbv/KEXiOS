//
//  LoaderDisplayable.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 30.05.2021.
//

import UIKit

protocol LoaderDisplayable: AnyObject {
    func showLoader()
    func hideLoader()
}

extension LoaderDisplayable where Self: UIViewController {
    func showLoader() {
        showLoader(animated: true, completion: { _ in })
    }

    func hideLoader() {
        hideLoader(animated: true, completion: { _ in })
    }

    private func showLoader(animated _: Bool, completion _: ((Bool) -> Void)? = nil) {
        view.endEditing(true)
        let animatedView = loadingView()

        guard let loadingView = animatedView else {
            let loadingView = BasicLoaderView(frame: view.bounds)
            view.addSubview(loadingView)
            view.bringSubviewToFront(loadingView)
            loadingView.center = view.center
            loadingView.showLoader()
            return
        }

        loadingView.isHidden = false
        loadingView.bringSubviewToFront(view)
        loadingView.center = view.center
        loadingView.showLoader()
    }

    private func hideLoader(animated _: Bool, completion _: ((Bool) -> Void)? = nil) {
        let loadingView: BasicLoaderView? = loadingView()

        if loadingView != nil {
            loadingView?.hideLoader()
            loadingView?.isHidden = true
        }
    }

    private func loadingView() -> BasicLoaderView? {
        var loadingView: BasicLoaderView?

        for currentView in view.subviews where currentView as? BasicLoaderView != nil {
            loadingView = currentView as? BasicLoaderView
            break
        }

        return loadingView
    }
}
