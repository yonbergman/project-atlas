//
//  DetailViewController.swift
//  atlas
//
//  Created by Yonatan Bergman on 6/6/14.
//  Copyright (c) 2014 Yonatan Bergman. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView : UIImageView

    var card: YBNetrunnerCard? {
        didSet {
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let card = self.card{
            self.navigationItem.title = card.title
            card.image(){ image in
                self.imageView.image = image
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }

    @IBAction func tap(sender : UITapGestureRecognizer) {
        self.dismissModalViewControllerAnimated(true)
    }
    
    override func shouldAutorotate() -> Bool {
        return false;
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.toRaw()
    }
    
}

