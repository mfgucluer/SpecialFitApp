import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var receipImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        receipImage.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(gotoRecipe))
        receipImage.addGestureRecognizer(gesture)
        
    }
    
    @objc func gotoRecipe() {
        print("fatih")
        performSegue(withIdentifier: "toRecipeVc", sender: nil)
        
    }

    
}

