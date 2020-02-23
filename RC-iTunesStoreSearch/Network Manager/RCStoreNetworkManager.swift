//
//  RCStoreNetworkManager.swift
//  RC iTunes Store Search
//
//  Created by dilgir siddiqui on 2/22/20.
//  Copyright © 2020 dilgir siddiqui. All rights reserved.
//

import Foundation
import UIKit

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
    
    func fetchImage(withURL url: URL, completionHandler: @escaping (ImageDownloadResult) -> Void) {
        let downloadRequest = URLRequest(url: url)
        let downloadTask = session.downloadTask(with: downloadRequest) { (url, response, error) in
            
            print("HTTP response Code: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
            print("URL Header Fields: \(String(describing: (response as? HTTPURLResponse)?.allHeaderFields))")

            guard error == nil else {
                completionHandler(.Failure(iTunesError.ImageDownloadError))
                return
            }
            if let downloadURL = url, let data = try? Data(contentsOf: downloadURL), let image = UIImage(data: data) {
                completionHandler(.Success(image))
            }

        }
        downloadTask.resume()
    }
}
