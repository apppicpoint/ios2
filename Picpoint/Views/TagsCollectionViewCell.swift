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
            //morado claro
            sender.backgroundColor = UIColor.init(red: 0.741176470588235, green: 0.623529411764706, blue: 0.768627450980392, alpha: 1)
        }else{
            state = true
            //morado oscuro
            sender.backgroundColor = UIColor.init(red: 0.505882352941176, green: 0, blue: 0.564705882352941, alpha: 1)
            
        }
    }
}

