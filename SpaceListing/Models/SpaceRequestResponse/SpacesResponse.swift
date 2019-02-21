//
//  PagedSpaceResponse.swift
//  SpaceListing
//
//  Created by Nury Garryyev on 1/21/19.
//  Copyright © 2019 Nury Garryyev. All rights reserved.
//

import Foundation

struct SpacesResponse: Decodable {
   
    let spaces: Spaces
    let total: Int

    enum CodingKeys: String, CodingKey {
        case spaces = "spaceList"
        case total = "totalCount"
    }
}
