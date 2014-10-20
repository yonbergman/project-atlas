//
//  YBCardTableViewCell.swift
//  atlas
//
//  Created by Yonatan Bergman on 6/8/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

class YBCardTableViewCell: UITableViewCell {

    @IBOutlet weak var factionImageView : UIImageView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var cardTypeLabel : UILabel!
    @IBOutlet weak var influenceLabel : UILabel!
    
    var influenceAttributes:NSDictionary?
    
    var card:YBNetrunnerCard?{
        didSet {
            self.configureView()
        }

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
            self.factionImageView.image = factionImage
            self.influence = card.influence
        }
    }
    
    var influence:Int = 0{
        didSet{
            if influenceAttributes == nil{
                influenceAttributes = self.influenceLabel.attributedText.attributesAtIndex(0, effectiveRange: nil)
            }
            let infStr = "•".x(self.influence)
            self.influenceLabel.attributedText = NSAttributedString(string: infStr, attributes: influenceAttributes)
        }
    }
    

}
