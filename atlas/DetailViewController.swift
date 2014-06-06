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
            // Update the view.
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
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tap(sender : UITapGestureRecognizer) {
        self.dismissModalViewControllerAnimated(true)
    }
    
    
}

