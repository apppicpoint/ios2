//
//  CustomAlertViewController.swift
//  Picpoint
//
//  Created by David on 30/01/2019.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import UIKit

class CustomAlertViewController: UIViewController {

    override func viewWillDisappear(_ animated: Bool) {
    }
    
    // Boton de cerrar alert
    @IBAction func closeAlert(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Boton de nueva publicación
    @IBAction func newPublication(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "newPublication", sender: sender)

    }
    
    // Boton de nuevo spot
    @IBAction func newSpot(_ sender: UIButton) {
        performSegue(withIdentifier: "mapNewSpot", sender: sender)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MapNewSpotViewController {
            let destination = segue.destination as! MapNewSpotViewController
            
        }
    }

}
