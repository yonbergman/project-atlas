//
//  YBSplashViewController.swift
//  atlas
//
//  Created by Yonatan Bergman on 10/19/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

class YBSplashViewController: UIViewController {

    @IBOutlet weak var iconView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var path = PocketSVG.pathFromSVGFileNamed("Credit").takeRetainedValue()
        let boundingBox = CGPathGetBoundingBox(path)
        let ratio = CGRectGetHeight(self.iconView.frame) / CGRectGetHeight(boundingBox)
        var t = CGAffineTransformMakeScale(ratio, ratio)
        t = CGAffineTransformTranslate(t, -CGRectGetMinX(boundingBox), -CGRectGetMinY(boundingBox))
        path = CGPathCreateCopyByTransformingPath(path, &t)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path
        shapeLayer.fillColor = UIColor.whiteColor().CGColor
        self.iconView.layer.addSublayer(shapeLayer)
    }
    
}
