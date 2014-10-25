//
//  YBMenuItemTableViewCell.swift
//  atlas
//
//  Created by Yonatan Bergman on 10/22/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

class YBMenuItemTableViewCell: UITableViewCell {

    @IBOutlet weak var setName: UILabel!
    @IBOutlet weak var checkmark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .Checkmark
        self.selected = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.checkmark.hidden = !selected
    }

}
