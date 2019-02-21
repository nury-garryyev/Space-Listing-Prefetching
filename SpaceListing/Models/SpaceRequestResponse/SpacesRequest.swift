//
//  SpacesRequest.swift
//  SpaceListing
//
//  Created by Nury Garryyev on 1/24/19.
//  Copyright © 2019 Nury Garryyev. All rights reserved.
//

import Foundation

struct SpacesRequest : DataRequest {
    var path: String
    var parameters: Parameters
    
    var offset = 0 {
        didSet {
            parameters["offset"] = "\(offset)"
        }
    }
    
    var max = 5 {
        didSet {
            parameters["max"] = "\(max)"
        }
    }
    
    var spaceType = "OFFICE" {
        didSet {
            parameters["spaceType"] = "\(spaceType)"
        }
    }
    
    init() {
        self.path = "rest/space/listByType"
        self.parameters = ["offset": "\(offset)", "max": "\(max)", "spaceType": "\(spaceType)"]
    }
}
