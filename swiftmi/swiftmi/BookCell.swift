//
//  BookCell.swift
//  swiftmi
//
//  Created by yangyin on 15/4/2.
//  Copyright (c) 2015年 swiftmi. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {

   
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var year: UILabel!
    
    @IBOutlet weak var author: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
