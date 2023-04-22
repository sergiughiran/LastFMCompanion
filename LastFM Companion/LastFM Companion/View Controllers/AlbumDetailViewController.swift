//
//  AlbumDetailViewController.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 12.06.2021.
//

import UIKit

private enum Constants {
    static let cellReuseIdentifier: String = "TrackTableViewCell"
    static let headerViewReuseIdentifier: String = "TableHeaderView"
    static let estimatedRowHeight: CGFloat = 40.0
    static let estimatedHeaderHeight: CGFloat = 80.0
    static let headerHeightMultiplier: CGFloat = 0.5
}

final class AlbumDetailViewController: BaseViewController, StoryboardPresentable {

    // MARK: - Outlets

    @IBOutlet private weak var albumTableView: UITableView!

    // MARK: - Public Properties

    var viewModel: AlbumDetailViewModel?

    // MARK: - Private Properties

    private var tableViewConfigurator: TableViewConfigurator<Track>?
    private lazy var albumHeaderView: AlbumHeaderView = {
        let headerView = AlbumHeaderView.instanceFromNib()
        headerView.delegate = self
        return headerView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupUI()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    // MARK: - Private Methods

    private func loadData() {
        startLoading()
        viewModel?.getAlbumDetails(completion: { [weak self] result in
            guard let self = self else { return }

            self.stopLoading()
            switch result {
            case .success(let album):
                DispatchQueue.main.async {
                    self.updateConfigurator(with: album)
                }
            case .failure(let error):
                self.showError(message: error.description)
            }
        })
    }

    private func setupUI() {
        albumTableView.tableFooterView = UIView()
        albumTableView.register(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: "TableHeaderView")
        albumTableView.rowHeight = UITableView.automaticDimension
        albumTableView.estimatedRowHeight = Constants.estimatedRowHeight
        albumTableView.sectionHeaderHeight = UITableView.automaticDimension
        albumTableView.estimatedSectionHeaderHeight = Constants.estimatedHeaderHeight

        tableViewConfigurator = TableViewConfigurator<Track>(
            cellReuseIdentifier: Constants.cellReuseIdentifier,
            cellConfigurator: { track, cell in
                guard let cell = cell as? TrackTableViewCell else { return }
                cell.setup(with: track)
            },
            headerReuseIdentifier: Constants.headerViewReuseIdentifier,
            headerViewConfigurator: { _, headerView in
                guard let headerView = headerView as? TableHeaderView else { return }
                headerView.setup(with: "Tracks")
            },
            emptyListLocation: .album
        )

        albumTableView.dataSource = tableViewConfigurator
        albumTableView.delegate = tableViewConfigurator
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func updateConfigurator(with album: Album) {
        navigationItem.title = album.name

        albumTableView.tableHeaderView = albumHeaderView
        albumHeaderView.frame = CGRect(x: 0, y: albumTableView.safeAreaInsets.top, width: albumTableView.bounds.width, height: albumTableView.bounds.height * Constants.headerHeightMultiplier)
        albumHeaderView.setup(with: album, isSaved: viewModel?.isSaved ?? false)

        view.layoutSubviews()
        
        guard let tracks = album.tracks else { return }

        tableViewConfigurator?.model = tracks
        albumTableView.reloadData()
    }
}

extension AlbumDetailViewController: AlbumHeaderViewDelegate {
    func handleSave() {
        guard let viewModel = viewModel else { return }

        viewModel.handleSave() { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let isSaved):
                self.albumHeaderView.updateSaved(isSaved: isSaved)
            case .failure(let error):
                self.showError(message: error.description)
            }
        }
    }

    func handleInfo() {
        viewModel?.handleInfo()
    }
}
