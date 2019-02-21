//
//  SpaceListViewController.swift
//  SpaceListing
//
//  Created by Nury Garryyev on 1/21/19.
//  Copyright © 2019 Nury Garryyev. All rights reserved.
//

import UIKit

class SpaceListViewController: UIViewController, AlertDisplayer  {

    private enum CellIdentifiers {
        static let spaceListCell = "SpaceListCollectionViewCell"
    }

    @IBOutlet weak var spaceListCollectionView: UICollectionView!
    @IBOutlet weak var spaceListCollectionViewActivityIndicatorView: UIActivityIndicatorView!
    
    private var viewModel: SpaceViewModel!
    private var shouldShowLoadingCell = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spaceListCollectionViewActivityIndicatorView.hidesWhenStopped = true
        spaceListCollectionViewActivityIndicatorView.color = ColorPalette.RWGreen
        spaceListCollectionViewActivityIndicatorView.startAnimating()
        
        spaceListCollectionView.isHidden = true
        spaceListCollectionView.dataSource = self
        spaceListCollectionView.delegate = self
        spaceListCollectionView.prefetchDataSource = self
        
        viewModel = SpaceViewModel(delegate: self)
        viewModel.fetchSpaces()
    }
}

extension SpaceListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = spaceListCollectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.spaceListCell, for: indexPath) as! SpaceListCollectionViewCell
        
        if isLoadingCell(for: indexPath) {
            cell.configureCell(with: .none)
        } else {
            cell.configureCell(with: viewModel.space(at: indexPath.row))
        }
        return cell
    }
}

extension SpaceListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height / 3)
    }
}

extension SpaceListViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchSpaces()
        }
    }
}

extension SpaceListViewController: SpaceViewModelDelegate {
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            spaceListCollectionViewActivityIndicatorView.stopAnimating()
            spaceListCollectionView.isHidden = false
            DispatchQueue.main.async {
                self.spaceListCollectionView.reloadData()
            }
            return
        }

        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        DispatchQueue.main.async {
            self.spaceListCollectionView.reloadItems(at: indexPathsToReload)
        }
    }
    
    func onFetchFailed(with reason: String) {
        spaceListCollectionViewActivityIndicatorView.stopAnimating()
        
        let title = "Warning".localizedString
        let action = UIAlertAction(title: "OK".localizedString, style: .default)
        displayAlert(with: title , message: reason, actions: [action])
    }
    
    func onDownloadCompleted(with indexPathToReload: IndexPath) {
        DispatchQueue.main.async {
            if self.spaceListCollectionView.indexPathsForVisibleItems.contains(indexPathToReload) {
                self.spaceListCollectionView.reloadItems(at: [indexPathToReload])
            }
            
        }
    }
}

    
private extension SpaceListViewController {
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.item >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = spaceListCollectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}


