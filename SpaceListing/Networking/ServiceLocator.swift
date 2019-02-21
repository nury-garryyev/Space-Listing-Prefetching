//
//  ServiceLocator.swift
//  SpaceListing
//
//  Created by Nury Garryyev on 1/22/19.
//  Copyright © 2019 Nury Garryyev. All rights reserved.
//

import Foundation

class ServiceLocator {
    static let instance: ServiceLocator = ServiceLocator()
    
    lazy var imageService: ImageService = ImageService()
    lazy var networkingService = NetworkingService()
}
