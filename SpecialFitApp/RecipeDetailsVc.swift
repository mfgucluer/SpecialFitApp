import UIKit
import CoreData

class RecipeDetailsVc: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    
    @IBOutlet weak var RecipeNameText: UITextField!
    @IBOutlet weak var RecipeImageView: UIImageView!
    @IBOutlet weak var ingredientsText: UITextView!
    @IBOutlet weak var preparationText: UITextView!
    @IBOutlet weak var RecipeNoteText: UITextView!
    @IBOutlet weak var proteinText: UITextField!
    @IBOutlet weak var caloriesText: UITextField!
    
    
    var chosenRecipe = ""
    var chosenRecipeID : UUID?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if chosenRecipe != ""
        {
            saveButton.isHidden = true
            RecipeImageView.isUserInteractionEnabled = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
            let idString = chosenRecipeID!.uuidString
            fetchRequest.predicate = NSPredicate(format: "recipeId = %@", idString)
            do
            {
                let results = try context.fetch(fetchRequest)
                if results.count>0
                {
                    for result in results as! [NSManagedObject]
                    {
                        
                        if let imageData = result.value(forKey: "image") as? Data{
                         let image = UIImage(data: imageData)
                            RecipeImageView.image = image
                        }
                        if let name = result.value(forKey: "name") as? String {
                            RecipeNameText.text = name
                        }
                        if let ingredients = result.value(forKey: "ingredients") as? String{
                            ingredientsText.text = ingredients
                        }
                        if let preparation = result.value(forKey: "preparation") as? String{
                            preparationText.text = preparation
                        }
                        if let note = result.value(forKey: "note") as? String {
                            RecipeNoteText.text = note
                        }
                        if let protein = result.value(forKey: "protein") as? Int{
                            proteinText.text = String(protein)
                        }
                        if let calories = result.value(forKey: "calories") as? Int{
                            caloriesText.text = String(calories)
                        }
                    }
                }
            }
            catch{print("error")}
        }
        else{
            //picking Image
                 
                 RecipeImageView.isUserInteractionEnabled = true
                 let gesturePickImage = UITapGestureRecognizer(target: self, action: #selector(pickImage))
                 RecipeImageView.addGestureRecognizer(gesturePickImage)
        }
        
    // Hiding keyboard
        let gestureHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(hidekeyboard))
        view.addGestureRecognizer(gestureHideKeyboard)
   
        
    

    }
    
    @objc func pickImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        RecipeImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    
    @objc func hidekeyboard()
    {
        view.endEditing(true)
    }
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newRecipe = NSEntityDescription.insertNewObject(forEntityName: "Recipe", into: context)
        
        //Saving all attributes
        let data = RecipeImageView.image?.jpegData(compressionQuality: 0.8)
        newRecipe.setValue(data, forKey: "image")
        newRecipe.setValue(UUID(), forKey: "recipeId")
        newRecipe.setValue(RecipeNameText.text, forKey: "name")
        newRecipe.setValue(ingredientsText.text, forKey: "ingredients")
        newRecipe.setValue(preparationText.text, forKey: "preparation")
        newRecipe.setValue(RecipeNoteText.text, forKey: "note")
        if let protein = Int(proteinText.text!){
            newRecipe.setValue(protein, forKey: "protein")
        }
        else{print("sayi yaz!!")}
        
        if let calories = Int(caloriesText.text!){
            newRecipe.setValue(calories, forKey: "calories")
        }
        else{print("sayi yaz!!")}
        
        do{
            try context.save()
            print("succes")
        }
        catch{
            print("error")
        }


        
        
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object:nil)
        
        
        
    }
    
    
    
}
