
import Alamofire
import UIKit

class SpotDetailViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var spotName: UILabel!
    @IBOutlet weak var author: UIButton!
    @IBOutlet weak var spotDescription: UILabel!
    @IBOutlet weak var createdBy: UILabel!
    @IBOutlet weak var TagCollectionView: UICollectionView!
    
    var spot = Spot()
    var tags:[Tag] = [Tag]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.TagCollectionView.delegate = self
        self.TagCollectionView.dataSource = self
        
        spotName.text = spot.name
        spotDescription.text = spot.desc
        
        getUserName()
        getSpotImage(imageName: spot.imageName!)
        //getTagsSpot()
        
        
        let flowLayout = TagCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        
        flowLayout?.scrollDirection = .horizontal
    }
    
    @IBAction func showInMapButton(_ sender: Any) {
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(String(describing: spot.latitude)),\(String(describing: spot.longitude))&directionsmode=driving")! as URL)
        } else {
            NSLog("Can't use comgooglemaps://");
        }
    }
    
    @IBAction func goAuthorProfile(_ sender: Any) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    /*func getTagsSpot(){
        let url = Constants.url+"spotHasTags"
        let headers: HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization":UserDefaults.standard.string(forKey: "token")!
        ]
        
        let parameters: Parameters = [
            "spot_id": spot.id,
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).responseJSON {
            response in
            
            print("spot_id: ", self.spot.id)
            
            self.tags = [Tag]()
           
            print("response.data:",response.data)
            print("response.result.value",response.result.value)
            
            
            if response.result.value == nil {
                print("No hay tags asociados")
            } else {
                let jsonResponse = response.result.value as! [String: Any]
                for _ in jsonResponse{
                    print(jsonResponse["id"], jsonResponse["name"])
                    self.tags.append(Tag(id: jsonResponse["id"] as! Int, name: jsonResponse["name"] as! String))
                     print("self.tags.count: ",self.tags.count)
                    print("********* array tags relleno ***********")
                }
            }
        }
    }*/
    
    func getSpotImage(imageName: String){
        let url = Constants.url+"imgFull/"+imageName //Se le pasa el nombre de la foto, el cual lo tiene el spot.
        Alamofire.request(url, method: .get).responseImage { response in
            switch response.result {
            case .success:
                let data = response.result.value
                self.image.image = data
            case .failure(let error):
                print("Sin conexión en get spot image")
                print(error)
                let alert = UIAlertController(title: "Ups! Something was wrong.", message:
                    "Check your connection and try it later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style:
                    .cancel, handler: { (accion) in}))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }

    func getUserName(){
        let url = Constants.url+"users/"+String(spot.user_id!)
        let _headers : HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization":UserDefaults.standard.string(forKey: "token")!
        ]
        
        Alamofire.request(url, method: .get, headers: _headers).responseJSON {
            response in
            let jsonResponse = response.result.value as! [String:Any]
            let data = jsonResponse["user"] as! [String: Any]
            self.author.titleLabel?.text = data["name"] as! String
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NewSpotViewController.tagsId.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = SpotTagCollectionViewCell()
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCellDetaill", for: indexPath) as! SpotTagCollectionViewCell
        cell.TagName.text = NewSpotViewController.tagsId[indexPath.row].name!
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let letras = NewSpotViewController.tagsId[indexPath.row].name?.count
        
        
        let dimensions = CGFloat((8 * letras!) + 20)
        return CGSize(width: dimensions,height: 40)
    }
    
}

