//
//  SearchTextField.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 06.06.2021.
//

import UIKit
import Combine

private enum Constants {
    static let attributedPlaceholder: NSAttributedString = NSAttributedString(string: "Search artists...", attributes: [.foregroundColor: UIColor(named: "captionColor") as Any])
    static let cornerRadius: CGFloat = 8.0
    static let font: UIFont = UIFont.systemFont(ofSize: 16.0, weight: .light)
    static let inset: CGFloat = 16.0
    static let accentColor: UIColor? = UIColor(named: "accentColor")
}

protocol SearchTextFieldDelegate: AnyObject {
    func searchTextDidChange(_ text: String)
}

final class SearchTextField: UITextField {

    // MARK: - Public Properties

    weak var searchDelegate: SearchTextFieldDelegate?

    // MARK: - Private Properties

    private lazy var searchImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)

        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20.0, weight: .light)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.color = .white
        indicator.style = .medium
        return indicator
    }()

    private var resultHandler: AnyCancellable?

    // MARK: - Lifecyle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupNotifications()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupNotifications()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupNotifications()
    }

    // MARK: - Public Methods

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x = Constants.inset
        return textRect
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= Constants.inset
        return textRect
    }

    func setLoading(_ isLoading: Bool) {
        rightViewMode = isLoading ? .always : .never
        rightView = loadingIndicator
        isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }

    // MARK: - Private Methods

    private func setupUI() {
        attributedPlaceholder = Constants.attributedPlaceholder
        font = Constants.font
        backgroundColor = Constants.accentColor
        textColor = .white
        leftView = searchImageView
        leftViewMode = .always
        returnKeyType = .search

        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
    }

    /// Handler for `UITextField.textChanged` notifications and for debouncing it in order to minimise the number of API requests.
    private func setupNotifications() {
        resultHandler = NotificationCenter
            .default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.global(qos: .userInteractive))
            .removeDuplicates()
            .sink { [weak self] searchString in
                self?.searchDelegate?.searchTextDidChange(searchString)
            }
    }
}
