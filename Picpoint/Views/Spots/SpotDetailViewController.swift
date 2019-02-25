
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
        
     
    }
    
    @IBAction func showInMapButton(_ sender: Any) {
        
    }
    

}
