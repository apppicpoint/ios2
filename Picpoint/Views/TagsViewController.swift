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




class TagsViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    var tags:[Tag] = [Tag]()
    var tagsSelected:[Tag] = [Tag]()
    var new: NewSpotViewController!

    
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        
        let flowLayout = tagsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        
        flowLayout?.scrollDirection = .vertical
        flowLayout?.minimumLineSpacing = 3
        flowLayout?.minimumInteritemSpacing = 3
        //flowLayout?.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        getTags()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tagsSelected = []
    }

    
    @IBAction func tagsBtnAction(_ sender: UIButton) {
        
        NewSpotViewController.tagsId = []
        
        for i in 0..<tagsSelected.count {
            
            if(tagsSelected[i].id == sender.tag){
                
                tagsSelected.remove(at: i)
                //print("tag eliminado")
                return
            }
        }
        
        for tag in tags {
            
            if(tag.id == sender.tag){
                tagsSelected.append(Tag(id: tag.id!, name: tag.name!))
            }
        }
        
        //print("tag añadido")
        
        //print("--------------------------")
        for tags in tagsSelected {
            print(tags)
        }
        //print("--------------------------")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(tags.count , "numero detags que hay")
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = TagsCollectionViewCell()
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! TagsCollectionViewCell
        cell.tagBtn.setTitle(tags[indexPath.row].name, for: .normal)
        cell.tagBtn.tag = tags[indexPath.row].id!
        
        for tag in NewSpotViewController.tagsId{
            
            if(tag.id == tags[indexPath.row].id){
                
                tagsSelected.append(Tag(id: tags[indexPath.row].id!, name: tags[indexPath.row].name!))
                cell.state = true
                cell.backgroundColor = UIColor.magenta
            }
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let letras = tags[indexPath.row].name?.count
        
        //print(tags[indexPath.row].name!)
        //print(letras!)
        //print("---------------------------------------")

        let dimensions = CGFloat((8 * letras!) + 20)
        return CGSize(width: dimensions,height: 40)
    }
    
    
    @IBAction func closeTagPopUp(_ sender: UIButton) {
        
        NewSpotViewController.clase?.tagCollectionView.reloadData()
        NewSpotViewController.tagsId.append(contentsOf: tagsSelected)
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
