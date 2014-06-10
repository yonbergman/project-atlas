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
    @IBOutlet var influenceLabel : UILabel
    
    var influenceAttributes:NSDictionary?
    
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
            self.factionImageView.image = factionImage
            self.influence = card.influence
        }
    }
    
    var influence:Int = 0{
        didSet{
            if (!influenceAttributes){
                influenceAttributes = self.influenceLabel.attributedText.attributesAtIndex(0, effectiveRange: nil)
            }
            let infStr = "•".x(self.influence)
            self.influenceLabel.attributedText = NSAttributedString(string: infStr, attributes: influenceAttributes)
        }
    }
    

}
