//
//  SearchViewController.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 05.06.2021.
//

import UIKit

private enum Constants {
    static let estimatedRowHeight: CGFloat = 45.0
    static let estimatedHeaderHeight: CGFloat = 40.0
    static let interGroupSpacing: CGFloat = 16.0
    static let tableViewInsets: UIEdgeInsets = UIEdgeInsets(top: 24.0, left: 24.0, bottom: 24.0, right: 24.0)
    static let footerHeight: CGFloat = 40.0
    static let artistCellKey: String = "ArtistTableViewCell"
    static let recentSearchCellKey: String = "RecentSearchTableViewCell"
    static let headerViewKey: String = "CollectionHeaderView"
}

final class SearchViewController: BaseViewController, StoryboardPresentable {

    // MARK: - Outlets

    @IBOutlet private weak var searchTextField: SearchTextField!
    @IBOutlet private weak var searchResultsTableView: UITableView!
    
    // MARK: - Public Properties

    var viewModel: SearchViewModel?

    // MARK: - Private Properties

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect.init(origin: .zero, size: CGSize(width: searchResultsTableView.bounds.width, height: Constants.footerHeight)))
        activityIndicator.color = .white
        return activityIndicator
    }()

    private var recentSearchesConfigurator: TableViewConfigurator<String>?
    private var searchResultsConfigurator: TableViewConfigurator<Artist>?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableConfigurators()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    // MARK: - Private Methods

    private func setupUI() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Search"

        searchResultsTableView.rowHeight = UITableView.automaticDimension
        searchResultsTableView.estimatedRowHeight = Constants.estimatedRowHeight
        searchResultsTableView.sectionHeaderHeight = UITableView.automaticDimension
        searchResultsTableView.estimatedSectionHeaderHeight = Constants.estimatedHeaderHeight
        searchResultsTableView.tableFooterView = UIView()
        searchResultsTableView.register(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.headerViewKey)

        searchResultsTableView.prefetchDataSource = self

        searchTextField.searchDelegate = self
    }

    private func setupTableConfigurators() {
        recentSearchesConfigurator = TableViewConfigurator(
            model: viewModel?.recentSearches.searches ?? [],
            cellReuseIdentifier: Constants.recentSearchCellKey,
            cellConfigurator: { model, cell in
                guard let cell = cell as? RecentSearchTableViewCell else { return }
                cell.setup(with: model)
            },
            cellActionConfigurator: { [weak self] searchString in
                guard let self = self else { return }

                self.searchTextField.text = searchString
                self.handleSearch(searchString)
            },
            headerReuseIdentifier: Constants.headerViewKey,
            headerViewConfigurator: { _, headerView in
                guard let headerView = headerView as? TableHeaderView else { return }
                headerView.setup(with: "Recent Searches")
            },
            isDeleteEnabled: true,
            deleteHandler: { [weak self] index in
                self?.viewModel?.removeRecentSearch(at: index)
            },
            emptyListLocation: .searchScreen
        )

        searchResultsConfigurator = TableViewConfigurator(
            cellReuseIdentifier: Constants.artistCellKey,
            cellConfigurator: { model, cell in
                guard let cell = cell as? ArtistTableViewCell else { return }
                cell.setup(with: model)
            },
            cellActionConfigurator: { [weak self] artist in
                self?.viewModel?.selectArtist(artist)
            },
            headerReuseIdentifier: Constants.headerViewKey,
            headerViewConfigurator: { _, headerView in
                guard let headerView = headerView as? TableHeaderView else { return }
                headerView.setup(with: "Search Results")
            },
            emptyListLocation: .searchScreen
        )

        searchResultsTableView.dataSource = recentSearchesConfigurator
        searchResultsTableView.delegate = recentSearchesConfigurator
    }

    private func scrollToTop() {
        searchResultsTableView.setContentOffset(.zero, animated: false)
        searchResultsTableView.reloadData()
        searchResultsTableView.layoutIfNeeded()
        searchResultsTableView.setContentOffset(.zero, animated: false)
    }

    private func updateConfigurator(with searchResults: [Artist]) {
        if !searchResults.isEmpty {
            self.searchResultsConfigurator?.model = searchResults
            self.searchResultsTableView.dataSource = self.searchResultsConfigurator
            self.searchResultsTableView.delegate = self.searchResultsConfigurator
        } else {
            self.searchResultsTableView.dataSource = self.recentSearchesConfigurator
            self.searchResultsTableView.delegate = self.recentSearchesConfigurator
        }
    }

    private func handleSearch(_ text: String) {
        DispatchQueue.main.async {
            self.searchTextField.setLoading(true)
        }

        viewModel?.searchArtist(text) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.searchTextField.setLoading(false)

                switch result {
                case .success(let searchResults):
                    self.updateConfigurator(with: searchResults)
                    self.scrollToTop()
                case .failure(let error):
                    self.showError(message: error.description)
                }
            }
        }
    }
}

extension SearchViewController: UITableViewDataSourcePrefetching {
    private func shouldLoadMoreResults(in indexPaths: [IndexPath]) -> Bool {
        guard let searchResults = viewModel?.searchResults else { return false }
        return indexPaths.contains(where: { $0.row == searchResults.count - 1 })
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if shouldLoadMoreResults(in: indexPaths) {
            searchResultsTableView.tableFooterView = activityIndicatorView
            activityIndicatorView.startAnimating()
            viewModel?.loadNextPage { [weak self] result in
                guard let self = self else { return }

                self.activityIndicatorView.stopAnimating()
                self.searchResultsTableView.tableFooterView = nil

                switch result {
                case .success(let searchResults):
                    self.updateConfigurator(with: searchResults)
                    self.searchResultsTableView.reloadData()
                case .failure(let error):
                    self.showError(message: error.description)
                }
            }
        }
    }
}

extension SearchViewController: SearchTextFieldDelegate {
    func searchTextDidChange(_ text: String) {
        handleSearch(text)
    }
}
