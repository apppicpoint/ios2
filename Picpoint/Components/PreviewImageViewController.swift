//
//  previewImageViewController.swift
//  Picpoint
//
//  Created by David on 31/01/2019.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import UIKit

class PreviewImageViewController: UIViewController {

    var longitude: Double?
    var latitude: Double?
    var image: UIImage?
    var imageName: String?
    var new: String?
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
    }
    
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func acceptBtn(_ sender: UIBarButtonItem) {
        
        print(self.new, new)
        
        if new == "spot"{
            performSegue(withIdentifier: "newSpot", sender: sender)
        }
        else{
            performSegue(withIdentifier: "newPub", sender: sender)
        }
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is NewSpotViewController {
            
            let destination = segue.destination as! NewSpotViewController
            destination.imageName = imageName
            destination.image = self.image!
            destination.longitude = longitude
            destination.latitude = latitude
        }
        
        if segue.destination is NewPublicationViewController {
            
            let destination = segue.destination as! NewPublicationViewController
            destination.imageName = imageName
            destination.image = self.image!

        }
    }

}
