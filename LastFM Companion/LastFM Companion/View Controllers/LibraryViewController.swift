//
//  LibraryViewController.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 27.05.2021.
//

import UIKit
import CoreData

private enum Constants {
    // The height for the album cell bottom label view. 40.0 is the minimum value in order to avoid label text cutting.
    static let albumCellDetailHeight: CGFloat = 40.0
    static let interItemSpacing: CGFloat = 16.0
    static let sectionInsets: UIEdgeInsets = UIEdgeInsets(top: 8.0, left: 24.0, bottom: 24.0, right: 24.0)
    static let headerReferenceSize: CGFloat = 40.0
    static let reuseIdentifier: String = "AlbumCollectionViewCell"
    static let headerReuseIdentifier: String = "CollectionHeaderView"
}

final class LibraryViewController: BaseViewController, StoryboardPresentable {

    // MARK: - Outlets

    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Public Properties

    var viewModel: LibraryViewModel?

    // MARK: - Private Properties

    private var collectionViewDataSource: CollectionViewDataSource<Album>?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupHandler()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Private Methods

    private func loadData() {
        viewModel?.loadData() { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self.collectionViewDataSource?.model = albums
                    self.collectionView.reloadData()
                    self.setupHandler()
                case .failure(let error):
                    self.showError(message: error.description)
                }
            }
        }
    }

    private func setupUI() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        searchButton.layer.cornerRadius = searchButton.frame.height / 2
        searchButton.layer.masksToBounds = true

        collectionView.register(UINib(nibName: Constants.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: Constants.reuseIdentifier)
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.headerReuseIdentifier)

        collectionView.setCollectionViewLayout(configuredLayout(), animated: false)
        collectionView.delegate = self

        collectionViewDataSource = CollectionViewDataSource(
            reuseIdentifier: Constants.reuseIdentifier,
            cellConfigurator: { model, cell in
                guard let cell = cell as? AlbumCollectionViewCell else { return }
                cell.setup(with: model, isSaved: true)
            },
            headerReuseIdentifier: Constants.headerReuseIdentifier,
            headerConfigurator: { _, headerView in
                guard let headerView = headerView as? CollectionHeaderView else { return }
                headerView.setup(with: "Albums")
            }
        )

        collectionView.dataSource = collectionViewDataSource
    }

    private func setupHandler() {
        let contextDidChangeHandler: ([Album]) -> Void = { [weak self] albums in
            guard let self = self else { return }

            self.collectionViewDataSource?.model = albums
            self.collectionView.reloadData()
        }

        viewModel?.contextDidChangeHandler = contextDidChangeHandler
    }

    private func configuredLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()

        layout.sectionInset = Constants.sectionInsets
        layout.minimumLineSpacing = Constants.interItemSpacing
        layout.minimumInteritemSpacing = Constants.interItemSpacing
        layout.headerReferenceSize = CGSize(width: collectionView.bounds.width, height: Constants.headerReferenceSize)

        return layout
    }

    @IBAction private func didTapSearchButton(_ sender: Any) {
        viewModel?.didSelectSearch()
    }
}

extension LibraryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.didSelectAlbum(at: indexPath.item)
    }
}

extension LibraryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.width - Constants.sectionInsets.left * 2 - Constants.interItemSpacing) / 2
        let itemHeight = itemWidth + Constants.albumCellDetailHeight
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
