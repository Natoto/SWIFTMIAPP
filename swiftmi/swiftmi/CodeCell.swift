//
//  CodeCell.swift
//  swiftmi
//
//  Created by yangyin on 15/4/1.
//  Copyright (c) 2015年 swiftmi. All rights reserved.
//

import UIKit

class CodeCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var preview: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
         super.awakeFromNib()
        //self.layer.cornerRadius = 4
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue:0.85, alpha: 0.9).CGColor
        self.layer.masksToBounds = false
        
       // addShadow()
       

    }
    
    func addShadow(){
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue:0, alpha: 0.3).CGColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2
        
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowPath =  UIBezierPath(rect: self.bounds).CGPath
         print(" ...add... shadow.....")
    }
    
    
}
