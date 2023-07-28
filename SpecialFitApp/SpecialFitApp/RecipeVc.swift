
import UIKit
import CoreData

class RecipeVc: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var nameArray = [String]()
    var idArray = [UUID]()
    var proteinArray = [Int]()
    var caloriesArray = [Int]()

    
    var selectedRecipe = ""
    var selectedRecipeId : UUID?
    
    
    
    
    
    
    
    
    @IBOutlet weak var progressBarView: UIProgressView!
    
    
    
    
    
    
    
    
    
    
    
    
    @IBOutlet weak var recipeViewController: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeViewController.delegate = self
        recipeViewController.dataSource = self
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        navigationItem.rightBarButtonItem = addButton
        getData()
        
    }
    
  
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
        getData()
        print("willappear calisti.")
    }
    
    
    
    @objc func getData(){
        
        nameArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        proteinArray.removeAll(keepingCapacity: false)
        caloriesArray.removeAll(keepingCapacity: false)
        
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(fetchRequest)
            for i in results as! [NSManagedObject] {
                self.nameArray.append(i.value(forKey: "name") as! String)
                self.idArray.append(i.value(forKey: "recipeId") as! UUID)
                self.proteinArray.append(i.value(forKey: "protein") as! Int)
                self.caloriesArray.append(i.value(forKey: "calories") as! Int)
                self.recipeViewController.reloadData()
            }
            }
        catch{
        print("error while getting data...")
        }
        
        }
    
    
  
    
    

    @objc func addButtonClicked(){
        
        selectedRecipe = ""
        performSegue(withIdentifier: "toRecipeDetailsVc", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toRecipeDetailsVc" {
            let destinationVC = segue.destination as! RecipeDetailsVc
            destinationVC.chosenRecipe = selectedRecipe
            destinationVC.chosenRecipeID = selectedRecipeId
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipe = nameArray[indexPath.row]
        selectedRecipeId = idArray[indexPath.row]
        
        performSegue(withIdentifier: "toRecipeDetailsVc", sender: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idArray.count    }
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = nameArray[indexPath.row]
        content.secondaryText = "Protein Miktari: \(String(proteinArray[indexPath.row]))          Kalori Miktari: \(String(caloriesArray[indexPath.row])) "
        cell.contentConfiguration = content
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
        
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
            let idString = idArray[indexPath.row].uuidString
            fetchRequest.predicate = NSPredicate(format: "recipeId = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(fetchRequest)
                if results.count>0{
                    for result in results as! [NSManagedObject]
                    {
                        if let id = result.value(forKey: "recipeId") as? UUID
                        {
                            if id == idArray[indexPath.row]
                            {
                                context.delete(result)
                                nameArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                self.recipeViewController.reloadData()
                                do
                                {
                                    try context.save()
                                    
                                }
                                catch{
                                    print("error silme islemindeki saveleme kismindadir.")
                                }
                                
                                break
                            }
                            
                        }
                    }
                }
            }
            catch{
                print("error silme isleminde...")
            }
        }
    }
    
    
    
}
