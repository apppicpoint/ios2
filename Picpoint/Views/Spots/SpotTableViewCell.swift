//
//  SpotTableViewCell.swift
//  Picpoint
//
//  Created by David on 01/02/2019.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import UIKit

class SpotTableViewCell: UITableViewCell {

    var id: Int?
    
    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var distanceTextField: UILabel!    
    @IBOutlet weak var spotImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
