
//  YBMenuItemTableViewCell.swift
//  atlas
//
//  Created by Yonatan Bergman on 10/22/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

class YBSetListViewCell: UITableViewCell {

    var set:YBNetrunnerSet!{
        didSet{
            self.setName.text = self.set.name
            self.cycleName.text = self.set.cycle
            if self.set.cycle == nil {
                self.cycleName.hidden = true
            }
            self.checkmarkImg.hidden = !self.set.selected
        }
    }
    @IBOutlet weak var setName: UILabel!
    @IBOutlet weak var cycleName: UILabel!
    @IBOutlet weak var checkmarkImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
