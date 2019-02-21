//
//  ImageDownloadingService.swift
//  SpaceListing
//
//  Created by Nury Garryyev on 1/22/19.
//  Copyright © 2019 Nury Garryyev. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

let imageCache = AutoPurgingImageCache(
    memoryCapacity: 100_000_000,
    preferredMemoryUsageAfterPurge: 60_000_000
)

public class ImageService {
    
    func loadImage(urlString: String, completionHandler: @escaping (UIImage?, String?) -> ()) {
        
        // Check cache for image
        if let cachedImage = imageCache.image(withIdentifier: urlString) {
            print("ImageService: Cached image")
            completionHandler(cachedImage, nil)
            return
        }
        
        // Convert urlString to URL
        guard let url = URL(string: urlString) else {
            print("ImageService: Wrong URL")
            completionHandler(cSpacePlaceholderImage, "Wrong URL!")
            return
        }
        
        // Fire off new download and return downloaded image or return placeholder with error message.
        Alamofire.request(url).responseImage { response in
            if let downloadedImage = response.result.value {
                imageCache.add(downloadedImage, withIdentifier: urlString)
                print("ImageService: Image downloaded")
                completionHandler(downloadedImage, nil)
            } else {
                print("ImageService: Fail to download image")
                completionHandler(cSpacePlaceholderImage, response.result.error?.localizedDescription)
            }
        }
        
    }
    
}
