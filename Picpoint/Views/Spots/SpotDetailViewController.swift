
import Alamofire
import UIKit

class SpotDetailViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var spotName: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var spotDescription: UILabel!
    @IBOutlet weak var createdBy: UILabel!
   
    var spot = Spot()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.image = spot.image
        spotName.text = spot.name
        spotDescription.text = spot.desc
        getUserName()
        
    }
    
    @IBAction func showInMapButton(_ sender: Any) {
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(String(describing: spot.latitude)),\(String(describing: spot.longitude))&directionsmode=driving")! as URL)
        } else {
            NSLog("Can't use comgooglemaps://");
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
            self.author.text = data["name"] as! String
           
        }
    }
    
}

