//
//  CollectionViewCell.swift
//  Picpoint
//
//  Created by alumnos on 19/2/19.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import UIKit

class TagsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tagBtn: UIButton!
    
    var state:Bool = false
    
    @IBAction func tagBtnAction(_ sender: UIButton) {
        
        if(state){
            
            state = false
            sender.backgroundColor = UIColor.purple
        }else{
            state = true
            sender.backgroundColor = UIColor.magenta
            
            
        }
    }
}

