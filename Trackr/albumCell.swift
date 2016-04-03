//
//  albumCell.swift
//  Trackr
//
//  Created by Omar Dlhz on 4/3/16.
//  Copyright © 2016 Omar De La Hoz. All rights reserved.
//

import UIKit

class albumCell: UITableViewCell {

    @IBOutlet weak var albumView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setCollectionViewDataSourceDelegate
        <D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>
        (dataSourceDelegate: D, forRow row: Int) {
            
            albumView.delegate = dataSourceDelegate
            albumView.dataSource = dataSourceDelegate
            albumView.tag = row
            albumView.reloadData()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
