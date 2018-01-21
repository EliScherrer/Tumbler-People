//
//  PhotoDetailsViewController.swift
//  Tumbler-People
//
//  Created by Eli Scherrer on 1/21/18.
//  Copyright © 2018 Eli Scherrer. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    
    @IBOutlet weak var photoView: UIImageView!
    var photoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoView.af_setImage(withURL: photoURL!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
