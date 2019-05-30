

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView?
    
    var employees: [Employee]? = []
    var departments: [Department]? = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        retrieveData()
    }
    
    @IBAction func createData(_ sender: Any) {
        createData()
    }
    
    @IBAction func retrieveData(_ sender: Any) {
        retrieveData()
    }
    
    @IBAction func updateData(_ sender: Any) {
        updateData()
    }
    
    @IBAction func deleteData(_ sender: Any) {
        deleteEmployeeData(row: 0)
    }
    
    @IBAction func deleteDepartmentData(_ sender: Any) {
        deleteDeptData(dept: 2)
    }
    
    @IBAction func addEmployeesInDepartment(_ sender: Any) {
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new records.
        let employeeEntity = NSEntityDescription.entity(forEntityName: "Employee", in: managedContext)!
        let deptEntity = NSEntityDescription.entity(forEntityName: "Department", in: managedContext)!
        
        //final, we need to add some data to our newly created record for each keys using
        //here adding 5 data with loop

        let j = (employees?.count)!+1
        for i in j...j+5 {
         
            //Now let’s create an entity and new records.
            let dept = NSManagedObject(entity: deptEntity, insertInto: managedContext) as! Department
            dept.id = "\(i)"
            dept.name = "Dept\(i)"
            
            let employee = NSManagedObject(entity: employeeEntity, insertInto: managedContext) as! Employee
            employee.id = "\(i)"
            employee.username = "Ankur\(i)"
            employee.email = "ankur\(i)@test.com"
            employee.password = "ankur\(i)"
            employee.department = dept
            
            do {
                try managedContext.save()
                retrieveData()
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    
    func createData(){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        let employeeEntity = NSEntityDescription.entity(forEntityName: "Employee", in: managedContext)!
        let deptEntity = NSEntityDescription.entity(forEntityName: "Department", in: managedContext)!

        //final, we need to add some data to our newly created record for each keys using
        //here adding 5 data with loop
        
        let i = (employees?.count)!+1
        //Now let’s create an entity and new records.
        let dept = NSManagedObject(entity: deptEntity, insertInto: managedContext) as! Department
        dept.id = "\(2)"
        dept.name = "Dept\(2)"
        
        let employee = NSManagedObject(entity: employeeEntity, insertInto: managedContext) as! Employee
        employee.id = "\(i)"
        employee.username = "Ankur\(i)"
        employee.email = "ankur\(i)@test.com"
        employee.password = "ankur\(i)"
        employee.department = dept
        
        
        //Now we have set all the values. The next step is to save them inside the Core Data
        
        do {
            try managedContext.save()
            retrieveData()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
    }
    
    
    
    
    
    func retrieveData() {
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        
        //        fetchRequest.fetchLimit = 1
        //        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur")
        //        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
        //
        do {
            let result = try managedContext.fetch(fetchRequest)
            employees = result as? [Employee]
            /*employees?.sort(by: { (emp1, emp2) -> Bool in
                
                let id1 : Int = Int((emp1.department?.id)!)!
                let id2 : Int = Int((emp2.department?.id)!)!
                
                return id1 < id2

            })*/
//            for data in result as! [NSManagedObject] {
//                print(data.value(forKey: "username") as! String)
//            }
            
        } catch {
            
            print("Failed")
        }
        
        tblView?.reloadData()
    }
    
    func updateData(){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Employee")
        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur1")
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            if test.isEmpty {
                return
            }
            
            let objectUpdate = test[0] as! NSManagedObject
            //objectUpdate.setValue("\(i)", forKeyPath: "id")
            objectUpdate.setValue("newName", forKey: "username")
            objectUpdate.setValue("newmail", forKey: "email")
            objectUpdate.setValue("newpassword", forKey: "password")
            do{
                try managedContext.save()
                retrieveData()
            }
            catch
            {
                print(error)
            }
            
            
        }
        catch
        {
            print(error)
        }
        
    }
    
    
    func deleteEmployeeData(row: Int){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            if test.isEmpty {
                return
            }
            
            let objectToDelete = test[row] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do{
                try managedContext.save()
                retrieveData()
            }
            catch
            {
                print(error)
            }
            
        }
        catch
        {
            print(error)
        }
    }
    
    
    func deleteDeptData(dept: Int){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Department")
        fetchRequest.predicate = NSPredicate(format: "id = %d", dept)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            if test.isEmpty {
                return
            }
            
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do{
                try managedContext.save()
                retrieveData()
            }
            catch
            {
                print(error)
            }
            
        }
        catch
        {
            print(error)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (employees?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: .default, reuseIdentifier: "cell")
            }
            return cell
        }()
        
        cell.textLabel?.text = (employees?[indexPath.row].username)!+" - "+(employees?[indexPath.row].department?.name)!
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            
            
            print("Delete: \(indexPath.row)")
            self.deleteEmployeeData(row: indexPath.row)
        }
        
        return [delete]
        
    }
}
