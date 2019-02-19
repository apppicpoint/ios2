//
//  TagsViewController.swift
//  Picpoint
//
//  Created by alumnos on 19/2/19.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class TagsViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var tags:[Tag]?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = TagsCollectionViewCell()
        return cell
    }
    @IBAction func closeTagPopUp(_ sender: UIButton) {
         self.dismiss(animated: true, completion: nil)
    }
    
    let url = Constants.url+"tag"
    let _headers : HTTPHeaders = [
        "Content-Type":"application/x-www-form-urlencoded",
        "Authorization":UserDefaults.standard.string(forKey: "token")!
    ]
    let parameters: Parameters = [
        "0":"0"
    ]
    func getTags() {
        
        Alamofire.request(url, method: .get,parameters: parameters, encoding: URLEncoding.httpBody, headers: _headers).responseJSON {
            response in
            
            switch response.result {
                case .success:
                    
                    if(response.response?.statusCode == 200){
                        
                        self.tags = [Tag]()
                        
                        let jsonResponse = response.result.value as! [String:Any]
                        let tags = jsonResponse["tags"] as! [[String: Any]]
                        
                        for tag in tags{
                        
                            self.tags?.append(Tag(id: tag["id"] as! Int, name: tag["name"] as! String))
                        }
                    }
                    break
                        
                        
            
                
                //Si falla la conexión se muestra un alert.
                case .failure(let error):
                    
                    print("Sin conexión en get tags")
                    print(error)
                    let alert = UIAlertController(title: "Ups! Something was wrong.", message:
                        "Check your connection and try it later", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ok", style:
                        .cancel, handler: { (accion) in}))
                    self.present(alert, animated: true, completion: nil)
                    break
  
            }
        }
    }
 
}
