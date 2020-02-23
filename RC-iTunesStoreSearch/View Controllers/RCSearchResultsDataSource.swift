//
//  RCSearchResultsDataSource.swift
//  RC iTunes Store Search
//
//  Created by dilgir siddiqui on 2/22/20.
//  Copyright © 2020 dilgir siddiqui. All rights reserved.
//

import Foundation
import  UIKit

class RCSearchResultsDataSource: NSObject, UITableViewDataSource {
    
    var searchResults = [RCSearchResult]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell") as! RCSearchResultTableViewCell
        let searchResult = searchResults[indexPath.row]
        
        cell.configure(for: searchResult)
        return cell

    }
    
}
