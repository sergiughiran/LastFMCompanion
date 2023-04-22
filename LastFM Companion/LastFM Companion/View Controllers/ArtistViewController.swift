//
//  ArtistViewController.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 09.06.2021.
//

import UIKit

private enum Constants {
    static let headerHeight: CGFloat = 300.0
    static let minimumHeaderHeight: CGFloat = 50.0
    // The height for the album cell bottom label view. 40.0 is the minimum value in order to avoid label text cutting.
    static let albumCellDetailHeight: CGFloat = 40.0
    static let interItemSpacing: CGFloat = 16.0
    static let sectionInsets: UIEdgeInsets = UIEdgeInsets(top: 8.0, left: 24.0, bottom: 24.0, right: 24.0)
    static let headerTransitionPadding: CGFloat = 100.0
    static let referenceSectionHeaderHeight: CGFloat = 40.0
    static let reuseIdentifier: String = "AlbumCollectionViewCell"
    static let headerReuseIdentifier: String = "CollectionHeaderView"
}

final class ArtistViewController: BaseViewController, StoryboardPresentable {

    // MARK: - Outlets

    @IBOutlet weak var albumsCollectionView: UICollectionView!

    // MARK: - Public Properties

    var viewModel: ArtistViewModel?

    // MARK: - Private Properties

    private var collectionViewDataSource: CollectionViewDataSource<Album>?

    private lazy var artistHeaderView: ArtistHeaderView = {
        let headerView = ArtistHeaderView.instanceFromNib()
        headerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return headerView
    }()

    /// The minimum height at which the navBar starts appearing. This height is the minimum point at which the header is still able to show enough information.
    private var minimumHeight: CGFloat {
        guard let navigationBar = navigationController?.navigationBar,
              let statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame
        else { return 0.0 }

        return navigationBar.frame.height + statusBarFrame.height
    }

    /// Property used to determine the last known alpha value for the `UINavigationBar`. This is used for updating the navigation bar when returning to the screen.
    private var currentTitleAlpha: CGFloat = 0.0

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateNavigationBar(with: currentTitleAlpha)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeader()
    }

    deinit {
        print("vc deinit")
    }

    // MARK: - Private Methods

    private func loadData() {
        startLoading()
        viewModel?.getTopAlbums(completion: { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.stopLoading()
                switch result {
                case .success(let albums):
                    self.setupCollectionView(with: albums)
                    self.setupHandler()
                case .failure(let error):
                    self.showError(message: error.description)
                }
            }
        })
    }

    private func setupUI() {
        extendedLayoutIncludesOpaqueBars = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        albumsCollectionView.register(UINib(nibName: Constants.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: Constants.reuseIdentifier)
        albumsCollectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.headerReuseIdentifier)

        albumsCollectionView.setCollectionViewLayout(configuredLayout(), animated: false)

        collectionViewDataSource = CollectionViewDataSource(
            reuseIdentifier: Constants.reuseIdentifier,
            cellConfigurator: { model, cell in
                guard let cell = cell as? AlbumCollectionViewCell, let viewModel = self.viewModel else { return }
                
                cell.setup(with: model, isSaved: viewModel.localAlbums.albumIDs.contains(model.id))
            },
            headerReuseIdentifier: Constants.headerReuseIdentifier,
            headerConfigurator: { _, headerView in
                guard let headerView = headerView as? CollectionHeaderView else { return }
                headerView.setup(with: "Albums")
            }
        )
    }

    private func setupHandler() {
        let contextDidChangeHandler: () -> Void = { [weak self] in
            DispatchQueue.main.async {
                self?.albumsCollectionView.reloadData()
            }
        }

        viewModel?.contextDidChangeHandler = contextDidChangeHandler
    }

    private func setupCollectionView(with albums: [Album]) {
        collectionViewDataSource?.model = albums
        albumsCollectionView.dataSource = collectionViewDataSource
        albumsCollectionView.delegate = self

        guard let viewModel = viewModel else { return }

        navigationItem.title = viewModel.artist.name
        artistHeaderView.setup(with: viewModel.artist)
    }

    private func configuredLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()

        layout.sectionInset = Constants.sectionInsets
        layout.minimumLineSpacing = Constants.interItemSpacing
        layout.minimumInteritemSpacing = Constants.interItemSpacing
        layout.headerReferenceSize = CGSize(width: albumsCollectionView.bounds.width, height: Constants.referenceSectionHeaderHeight)

        return layout
    }

    private func updateHeader() {
        guard albumsCollectionView.backgroundView == nil else { return }

        albumsCollectionView.backgroundView = UIView()
        albumsCollectionView.backgroundView?.addSubview(artistHeaderView)

        artistHeaderView.frame = CGRect(x: 0, y: 0, width: albumsCollectionView.frame.width, height: Constants.headerHeight)
        albumsCollectionView.contentInset = UIEdgeInsets(top: Constants.headerHeight - albumsCollectionView.safeAreaInsets.top, left: 0, bottom: 0, right: 0)

        artistHeaderView.height = Constants.headerHeight
        artistHeaderView.minHeight = minimumHeight + Constants.headerTransitionPadding / 2

        view.layoutSubviews()
    }

    private func updateNavigationBar(with alpha: CGFloat) {
        navigationController?.navigationBar.isTranslucent = alpha < 1
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.black.withAlphaComponent(alpha)) ?? UIImage(), for: .default)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(alpha)]
    }

    @objc private func localAlbumsDidUpdate() {
        DispatchQueue.main.async {
            self.albumsCollectionView.reloadData()
        }
    }
}

extension ArtistViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let referenceHeight = Constants.headerHeight
        
        let offset = referenceHeight + scrollView.contentOffset.y
        let targetHeight = referenceHeight - offset

        var headerFrame = artistHeaderView.frame
        headerFrame.size.height = max(minimumHeight, targetHeight)

        artistHeaderView.frame = headerFrame
        artistHeaderView.updateAppearance(with: targetHeight)

        let distanceFromNavBar = targetHeight - minimumHeight
        self.updateNavigationBar(with: distanceFromNavBar)
        var alpha: CGFloat = 0.0
        if distanceFromNavBar < 0 {
            alpha = 1.0
        } else if (0.0..<Constants.headerTransitionPadding).contains(distanceFromNavBar) {
            alpha = 1 - distanceFromNavBar / Constants.headerTransitionPadding
        }

        updateNavigationBar(with: alpha)
        currentTitleAlpha = alpha
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.showAlbumDetail(at: indexPath.item)
    }
}

extension ArtistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.width - Constants.sectionInsets.left * 2 - Constants.interItemSpacing) / 2
        let itemHeight = itemWidth + Constants.albumCellDetailHeight
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
