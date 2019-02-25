//
//  SpotTableViewCell.swift
//  Picpoint
//
//  Created by David on 01/02/2019.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import UIKit

class SpotCollectionViewCell: UICollectionViewCell {

    var id: Int?
    var index: Int?
    
    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var distanceTextField: UILabel!    
    @IBOutlet weak var spotImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        spotImage.layer.masksToBounds = true
        spotImage.clipsToBounds = true
        
        //spotImage.contentMode = .scaleAspectFill
        // Initialization code
    }
    
    



}
