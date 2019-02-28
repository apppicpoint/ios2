
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
    var tagsHardcoded = [Tag]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.TagCollectionView.delegate = self
        self.TagCollectionView.dataSource = self
        
        spotName.text = spot.name
        spotDescription.text = spot.desc
        
        getUserName()
        getSpotImage(imageName: spot.imageName!)
        getTagsSpot()
        print(spot.id!)
        
        //tagsHardcoded.append(Tag(id: 2, name: "Hola"))
        
        let flowLayout = TagCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        
        flowLayout?.scrollDirection = .horizontal
        
        self.TagCollectionView.reloadData()
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
    
    func getTagsSpot(){
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
                    
                    print("tags.count",tags.count)
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
            self.author.titleLabel?.text = data["nickName"] as? String
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spot.tags!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = SpotDetailTagCollectionViewCell()
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spotDetailTagCell", for: indexPath) as! SpotDetailTagCollectionViewCell
        print("cell tag name",cell.SpotTagName.text)
        cell.SpotTagName.text = spot.tags![indexPath.row].name
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let letras = spot.tags![indexPath.row].name?.count
        let dimensions = CGFloat((8 * letras!) + 20)
        return CGSize(width: dimensions,height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let totalCellWidth = 80 * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = 10 * (collectionView.numberOfItems(inSection: 0) - 1)
        
        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
        
    }
    
    
}

