//
//  NetworkingService.swift
//  SpaceListing
//
//  Created by Nury Garryyev on 1/21/19.
//  Copyright © 2019 Nury Garryyev. All rights reserved.
//

import Foundation
import Alamofire

private var baseURL: URL = {
    return URL(string: cBaseUrl)!
}()

class NetworkingService {
 
    typealias CompletionHandler = (Result<Decodable, DataResponseError>) -> Void
    
    func fetch<T: Decodable>(with request: DataRequest, decodingType: T.Type, completionHandler completion: @escaping CompletionHandler) {

        let url = request.url
        let parameters = request.parameters
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON {
            response in
            switch response.result {
                case .success:
                    guard let decodedResponse = try? JSONDecoder().decode(decodingType, from: response.data!) else {
                        completion(Result.failure(DataResponseError.decoding))
                        return
                    }
                    completion(Result.success(decodedResponse))
                case .failure:
                    completion(Result.failure(DataResponseError.network))
                    return
            }
        }
    }
}
