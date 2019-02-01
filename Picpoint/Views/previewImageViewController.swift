//
//  previewImageViewController.swift
//  Picpoint
//
//  Created by David on 31/01/2019.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import UIKit

class previewImageViewController: UIViewController {

    var image: UIImage?
    var imageName: String?
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goToNewSpot(_ sender: UIButton) {
        performSegue(withIdentifier: "newSpot", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is NewSpotViewController {
            
            let destination = segue.destination as! NewSpotViewController
            destination.imageName = imageName
            destination.image = self.image!
        }
    }

}
