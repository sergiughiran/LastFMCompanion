//
//  InfoViewController.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 14.06.2021.
//

import UIKit

private enum Constants {
    static let textViewInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
}

final class InfoViewController: UIViewController, StoryboardPresentable {

    // MARK: - Outlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var infoTextView: UITextView!

    // MARK: - Public Properties

    var viewModel: InfoViewModel?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private Methods

    private func setupUI() {
        infoTextView.contentInset = Constants.textViewInset

        titleLabel.text = viewModel?.title
        infoTextView.text = viewModel?.info
    }

    @IBAction private func didTapDoneButton(_ sender: Any) {
        dismiss(animated: true)
    }
}
