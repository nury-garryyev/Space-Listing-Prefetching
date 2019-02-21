//
//  Space.swift
//  SpaceListing
//
//  Created by Nury Garryyev on 1/21/19.
//  Copyright © 2019 Nury Garryyev. All rights reserved.
//

import UIKit

typealias Spaces = [Space]

struct Space: Decodable, Equatable {
    let spaceImageId: Int
    let spaceImageUrl: String
    var spaceImage: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case spaceImageId = "id"
        case spaceImageUrl = "img"
    }
    
    static func == (lhs: Space, rhs: Space) -> Bool {
        return lhs.spaceImageUrl == rhs.spaceImageUrl
    }
}
