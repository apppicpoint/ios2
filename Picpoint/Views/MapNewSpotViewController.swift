//
//  MapNewSpotViewController.swift
//  Picpoint
//
//  Created by David on 30/01/2019.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import UIKit

class MapNewSpotViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func close(_ sender: UIBarButtonItem) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) //Coge la referencia del storyboard
        //Declará el viewController al que se quiere acceder y abre sin necesidad de segue.
        //Es la mejor opción, ya que con segue se arrastraría el navigationController y el tabBarController.
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "app")
        self.present(newViewController, animated: false, completion: nil)
    }
    
    @IBAction func goToCamera(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "camera", sender: sender)
    }
    
}
