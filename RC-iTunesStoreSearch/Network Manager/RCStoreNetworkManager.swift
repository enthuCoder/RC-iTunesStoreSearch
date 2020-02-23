//
//  RCStoreNetworkManager.swift
//  RC iTunes Store Search
//
//  Created by dilgir siddiqui on 2/22/20.
//  Copyright © 2020 dilgir siddiqui. All rights reserved.
//

import Foundation

class RCStoreNetworkManager {
    
    // Computed property for URL session
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
}

extension RCStoreNetworkManager {
    
    func searchItunesStore(withSearchParameters searchParameters: [String: String], completionHandler: @escaping (SearchResult) -> Void) {
        
        let url = RCiTunesAPI.storeSearchURL(forParameters: searchParameters)
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            print("HTTP response Code: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
            print("URL Header Fields: \(String(describing: (response as? HTTPURLResponse)?.allHeaderFields))")
            
            if let err = error {
                completionHandler(.Failure(err))
            }
            guard let jsonData = data else {
                return completionHandler(.Failure(error!))
            }
            let result = RCiTunesAPI.searchResultFromJSONData(data: jsonData)
            completionHandler(result)
        }
        dataTask.resume()
    }
    
    
}
