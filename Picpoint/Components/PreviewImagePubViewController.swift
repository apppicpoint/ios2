//
//  PreviewImagePubViewController.swift
//  Picpoint
//
//  Created by alumnos on 25/2/19.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import Foundation

import UIKit

class PreviewImagePubViewController: UIViewController {
    
    var image: UIImage?
    var imageName: String?
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
    }
    
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func acceptBtn(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "newPub", sender: sender)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is NewPublicationViewController {
            
            let destination = segue.destination as! NewPublicationViewController
            destination.imageName = imageName
            destination.image = self.image!

        }
    }
    
}
