//
//  MovieTableViewCell.swift
//  BuscadorItunes
//
//  Created by Desarrollo AWS on 13/7/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet var imgMovie: UIImageView!
    @IBOutlet var trackName: UILabel!
    @IBOutlet var longDescription: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
