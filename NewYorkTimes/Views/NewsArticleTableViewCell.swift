//
//  NewsArticleTableViewCell.swift
//  NewYorkTimes
//
//  Created by Ananth Kamath on 09/06/22.
//

import UIKit

class NewsArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var abstractLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        
        abstractLabel.lineBreakMode = .byWordWrapping
        abstractLabel.numberOfLines = 0
    }
    
}
