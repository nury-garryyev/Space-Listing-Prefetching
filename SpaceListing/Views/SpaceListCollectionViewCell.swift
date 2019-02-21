//
//  SpaceListCollectionViewCell.swift
//  SpaceListing
//
//  Created by Nury Garryyev on 1/21/19.
//  Copyright © 2019 Nury Garryyev. All rights reserved.
//

import UIKit

class SpaceListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var spaceImageView: UIImageView!
    @IBOutlet weak var spaceImageActivityIndicatorView: UIActivityIndicatorView!

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.configureCell(with: .none)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        spaceImageView.image = cSpacePlaceholderImage
        
        spaceImageActivityIndicatorView.hidesWhenStopped = true
        spaceImageActivityIndicatorView.color = ColorPalette.RWGreen
        spaceImageActivityIndicatorView.startAnimating()
    }
    
    func configureCell(with space: Space?) {
        if let space = space, let spaceImage = space.spaceImage {
            spaceImageView.image = spaceImage
            spaceImageActivityIndicatorView.stopAnimating()
        } else {
            spaceImageView.image = cSpacePlaceholderImage
            spaceImageActivityIndicatorView.startAnimating()
        }
    }
}
