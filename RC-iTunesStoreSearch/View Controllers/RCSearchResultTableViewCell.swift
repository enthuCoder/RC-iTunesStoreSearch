//
//  RCSearchResultTableViewCell.swift
//  RC iTunes Store Search
//
//  Created by dilgir siddiqui on 2/22/20.
//  Copyright © 2020 dilgir siddiqui. All rights reserved.
//

import UIKit

class RCSearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    var downloadTask: URLSessionDownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let selectedView = UIView(frame: .zero)
        selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
        selectedBackgroundView = selectedView
    }
    
    public func configure(for result: RCSearchResult) {
        nameLabel.text = result.name
        
        if result.artistName.isEmpty {
            artistNameLabel.text = "Unknown"
        } else {
            artistNameLabel.text = String(format: "%@ (%@)", result.artistName, result.type)
        }
        
        artworkImageView.image = UIImage(named: "Placeholder")
//        if let smallURL = URL(string: result.imageSmall) {
//            downloadTask = artworkImageView.loadImage(url: smallURL)
//        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

