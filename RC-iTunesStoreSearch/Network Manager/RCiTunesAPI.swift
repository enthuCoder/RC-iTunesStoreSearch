//
//  RCiTunesAPI.swift
//  RC iTunes Store Search
//
//  Created by dilgir siddiqui on 2/22/20.
//  Copyright © 2020 dilgir siddiqui. All rights reserved.
//

import Foundation
import UIKit

enum iTunesSearchMethod: String {
    case search = "/search"
}

enum SearchResult {
    case Success([RCSearchResult])
    case Failure(Error)
}

enum ImageDownloadResult {
    case Success(UIImage)
    case Failure(Error)
}

enum iTunesError: Error {
    case InvalidJSONData // Invalid Json error for iTunes Search API call
    case ImageDownloadError
}

struct RCiTunesAPI {
    
    private static let baseURL = "https://itunes.apple.com"
    
    static func storeSearchURL(forParameters parameters: [String: String]) -> URL {
        
        let searchText = parameters["searchText"]!
        let kind = parameters["kind"]!
        
        let encodedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let urlString = baseURL + iTunesSearchMethod.search.rawValue + String(format: "?term=%@&limit=200&entity=\(kind)", encodedSearchText)
        return URL(string: urlString)!
    }
    
    static func searchResultFromJSONData(data: Data) -> SearchResult {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(SearchResults.self, from: data)
            print("Response: \(String(describing: response))")
            return .Success(response.results)
        } catch {
            return .Failure(iTunesError.InvalidJSONData)
        }
    }
}
