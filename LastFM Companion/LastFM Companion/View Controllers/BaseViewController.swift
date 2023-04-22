//
//  BaseViewController.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 16.06.2021.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Loading

    lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(style: .large)

        loadingView.backgroundColor = .black
        loadingView.color = .white
        loadingView.frame = view.frame

        return loadingView
    }()

    func startLoading() {
        view.addSubview(loadingView)
        loadingView.startAnimating()
    }

    func stopLoading() {
        loadingView.stopAnimating()
        loadingView.removeFromSuperview()
    }

    // MARK: - Error

    func showError(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .cancel))
        self.present(alertController, animated: true)
    }
}
