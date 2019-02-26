
import Alamofire
import UIKit

class SpotDetailViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var spotName: UILabel!
    @IBOutlet weak var author: UIButton!
    @IBOutlet weak var spotDescription: UILabel!
    @IBOutlet weak var createdBy: UILabel!
   
    var spot = Spot()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        spotName.text = spot.name
        spotDescription.text = spot.desc
        getUserName()
        getSpotImage(imageName: spot.imageName!)
        
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
    
    /*func getTagsSpot(){
        let url = Constants.url+"spotTag"+String(spot.id!)
        let headers: HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization":UserDefaults.standard.string(forKey: "token")!
        ]
        
        Alamofire.request(url, method: .get, headers: headers) {
            response in
            
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
    
}

