//
//  SpaceRequest.swift
//  SpaceListing
//
//  Created by Nury Garryyev on 1/21/19.
//  Copyright © 2019 Nury Garryyev. All rights reserved.
//

import Foundation

typealias Parameters = [String: String]

protocol DataRequest {
    var path: String { get }
    var parameters: Parameters { get set }
}

extension DataRequest {
    var url: URL {
        if let url = URL(string: cBaseUrl + path) {
            return url
        } else {
            fatalError()
        }
    }
}
