//
//  SongCell.swift
//  Trackr
//
//  Created by Omar Dlhz on 3/22/16.
//  Copyright © 2016 Omar De La Hoz. All rights reserved.
//

import UIKit

class SongCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var songAction: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
