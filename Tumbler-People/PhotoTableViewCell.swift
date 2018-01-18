//
//  PhotoTableViewCell.swift
//  Tumbler-People
//
//  Created by Eli Scherrer on 1/14/18.
//  Copyright © 2018 Eli Scherrer. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var photoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

/*file: Main.storyboard: error: Illegal Configuration: The PhotoCell outlet from the PhotosViewController to the PhotoTableViewCell is invalid. Outlets cannot be connected to repeating content.
*/

