//
//  SpaceViewModel.swift
//  SpaceListing
//
//  Created by Nury Garryyev on 1/21/19.
//  Copyright © 2019 Nury Garryyev. All rights reserved.
//

import Foundation

protocol SpaceViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
    func onDownloadCompleted(with indexPathToReload: IndexPath)
}

final class SpaceViewModel {
    
    private weak var delegate: SpaceViewModelDelegate?
    
    private var spaces: Spaces = []
    private var request: SpacesRequest = SpacesRequest()
    private var total: Int = 0
    private var isFetchInProgress: Bool = false
    
    init(delegate: SpaceViewModelDelegate) {
        self.delegate = delegate
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return spaces.count
    }

    func space(at index: Int) -> Space {
        return spaces[index]
    }
    
    func fetchSpaces() {

        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        
        ServiceLocator.instance.networkingService.fetch(with: request, decodingType: SpacesResponse.self) { result in
            switch result {

            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                }

            case .success(let response):
                
                guard let spaceResponse = response as? SpacesResponse else { fatalError() }
                
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.request.offset += 1
                    self.total = spaceResponse.total

                    for space in spaceResponse.spaces {
                        if !self.spaces.contains(where: { $0 == space }) {
                            self.spaces.append(space)
                            self.downloadImage(forItemAtIndex: self.spaces.count - 1)
                            
                        }
                    }

                    if self.request.offset > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: spaceResponse.spaces)
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.delegate?.onFetchCompleted(with: .none)
                    }
                }
            }
        }
    }
    
    private func calculateIndexPathsToReload(from newSpaces: Spaces) -> [IndexPath] {
        let startIndex = spaces.count - newSpaces.count
        let endIndex = startIndex + newSpaces.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    private func downloadImage(forItemAtIndex index: Int) {

        ServiceLocator.instance.imageService.loadImage(urlString: spaces[index].spaceImageUrl, completionHandler: { (downloadedImage, errorMessage) in
            
            if let errorMessage = errorMessage {
                print("Error: Fail to download image: \(errorMessage)")
            }
            
            if let downloadedImage = downloadedImage {
                self.spaces[index].spaceImage = downloadedImage
                self.delegate?.onDownloadCompleted(with: IndexPath(row: index, section: 0))
            }
        })
    }
}
