//
//  NoLoggedViewController.swift
//  Picpoint
//
//  Created by David on 07/02/2019.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import UIKit

class NoLoggedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func singIn(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "token") //Borra el token guardado en el dispositivo.
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "role_id")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) //Coge la referencia del storyboard
        
        //Declará el viewController al que se quiere acceder y abre sin necesidad de segue.
        //Es la mejor opción, ya que con segue se arrastraría el navigationController y el tabBarController.
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "singIn") as! LoginViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func singUp(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "token") //Borra el token guardado en el dispositivo.
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "role_id")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) //Coge la referencia del storyboard
        
        //Declará el viewController al que se quiere acceder y abre sin necesidad de segue.
        //Es la mejor opción, ya que con segue se arrastraría el navigationController y el tabBarController.
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "singUp") as! RegisterViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
}
