//
//  YBCardTableViewCell.swift
//  atlas
//
//  Created by Yonatan Bergman on 6/8/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

class YBCardTableViewCell: UITableViewCell {

    @IBOutlet var factionImageView : UIImageView
    @IBOutlet var titleLabel : UILabel
    @IBOutlet var cardTypeLabel : UILabel
    
    var card:YBNetrunnerCard?{
        didSet {
            self.configureView()
        }

    
    }
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureView(){
        if let card = self.card{
            titleLabel.text = card.title
            cardTypeLabel.text = card.subtitle
            let factionImage = UIImage(named: "\(card.faction).png")
            factionImageView.image = factionImage
        }
    }
    

}
