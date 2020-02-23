//
//  RCStoreSearchViewController.swift
//  RC iTunes Store Search
//
//  Created by dilgir siddiqui on 2/22/20.
//  Copyright © 2020 dilgir siddiqui. All rights reserved.
//

import UIKit

enum TableViewCellIdentifiers: String {
    case searchResultCell = "SearchResultCell"
    case nothingFoundCell = "NothingFoundCell"
    case loadingCell = "LoadingCell"
}

class RCStoreSearchViewController: UIViewController {

    // Network Manager
    var storeManager: RCStoreNetworkManager!
    
    // Outlets for UI Controls
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var chosenCategorySegControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    let resultsTableViewDataSource = RCSearchResultsDataSource()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show typing active for Search
        searchBar.becomeFirstResponder()
        
        tableView.rowHeight = 80.0
        
        // Register table view cell UIs
        registerTableViewCellNibs()
        
        // Setup Delegates and Datasources
        searchBar.delegate = self
        tableView.dataSource = resultsTableViewDataSource
        tableView.delegate = self
        
        navigationItem.titleView?.tintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
        
    }
    
}

// MARK: - Helper Methods
extension RCStoreSearchViewController {
    
    private func registerTableViewCellNibs() {
        var tableViewCellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell.rawValue, bundle: Bundle.main)
        tableView.register(tableViewCellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell.rawValue)
        
        tableViewCellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell.rawValue, bundle: Bundle.main)
        tableView.register(tableViewCellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell.rawValue)

        tableViewCellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell.rawValue, bundle: Bundle.main)
        tableView.register(tableViewCellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell.rawValue)
    }

    func performSearch(for searchText: String?) {
        guard let searchText = searchText  else {
            print("Searching for empty text...")
            return
        }
        
        searchBar.resignFirstResponder()
        
        let searchParameters = ["searchText" : searchText, "kind" : selectedCategoty()]
        storeManager.searchItunesStore(withSearchParameters: searchParameters) { (result) in
            switch result {
                case let .Success(searchResult):
                    print("Successfully found search results \(searchResult).")
                    DispatchQueue.main.async {
                        self.resultsTableViewDataSource.searchResults = searchResult
                        self.tableView.reloadData()
                    }
                
                case let .Failure(error):
                    print("Error while checking iTunes Store: \(error).")
            }
        }
    }
    
    private func selectedCategoty() -> String {
        var category: String
        switch  chosenCategorySegControl.selectedSegmentIndex {
            case 1: category = "musicTrack"
            case 2: category = "ebook"
            case 3: category = "software"
            default: category = ""
        }
        return category
    }

}

extension RCStoreSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch(for: searchBar.text)
    }
}

extension RCStoreSearchViewController {
    
    @IBAction func chosenCategoryChanged(_ sender: UISegmentedControl) {
        performSearch(for: searchBar.text)
    }
}

extension RCStoreSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let item = resultsTableViewDataSource.searchResults[indexPath.row]
        if let smallImageURL = URL(string: item.imageSmall) {
            print("Fetching image from: \(item.imageSmall)")
            storeManager.fetchImage(withURL: smallImageURL) { (result) in
                switch result {
                    case let .Success(image):
                        print("Downloaded Image")
                        DispatchQueue.main.async {
                            (cell as! RCSearchResultTableViewCell).artworkImageView.image = image
                        }
                    case let .Failure(error):
                        print("Image download failed with error: \(error)")
                }
            }
        }
    }
}
