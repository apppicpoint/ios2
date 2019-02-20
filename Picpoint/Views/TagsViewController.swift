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
    
    var tags:[Tag] = [Tag]()
    
    
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        
        let flowLayout = tagsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        
        flowLayout?.scrollDirection = .vertical
        flowLayout?.minimumLineSpacing = 0
        flowLayout?.minimumInteritemSpacing = 0
        flowLayout?.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        
        getTags()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(tags.count , "numero detags que hay")
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = TagsCollectionViewCell()
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! TagsCollectionViewCell
        cell.tagBtn.setTitle(tags[indexPath.row].name, for: .normal)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalwidth = collectionView.bounds.size.width;
        let numberOfCellsPerRow = 3
        let oddEven = indexPath.row / numberOfCellsPerRow % 2
        let dimensions = CGFloat(Int(totalwidth) / numberOfCellsPerRow)
        if (oddEven == 0) {
            return CGSize(width: dimensions,height: dimensions)
        } else {
            return CGSize(width: dimensions,height: dimensions / 2)
        }
    }
    
    
    @IBAction func closeTagPopUp(_ sender: UIButton) {
         self.dismiss(animated: true, completion: nil)
    }
    
    let url = Constants.url+"tag"
    let _headers : HTTPHeaders = [
        "Content-Type":"application/x-www-form-urlencoded",
        "Authorization":UserDefaults.standard.string(forKey: "token")!
    ]

    func getTags() {
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.httpBody, headers: _headers).responseJSON {
            response in
            
            switch response.result {
                case .success:
                    
                    if(response.response?.statusCode == 200){
                        
                        self.tags = [Tag]()
                        print("getTags 200")
                        let jsonResponse = response.result.value as! [String:Any]
                        let tags = jsonResponse["tags"] as! [[String: Any]]
                        
                        for tag in tags{
                        
                            self.tags.append(Tag(id: tag["id"] as! Int, name: tag["name"] as! String))
                        }
                        self.tagsCollectionView.reloadData()
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
