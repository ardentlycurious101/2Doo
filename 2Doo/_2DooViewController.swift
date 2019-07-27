//
//  ViewController.swift
//  2Doo
//
//  Created by Elina Lua Ming on 7/22/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit
import CoreData

class _2DooViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)        
    }

    // MARK: TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "2DooItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    // MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // TODO: Create UIAlert dialog pop-up
        let alert = UIAlertController(title: "Add New 2Doo item", message: "", preferredStyle: .alert)
        
        // TODO: Create UIAlertAction
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                        
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "xyz"
            
            textField = alertTextField
        }
        
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: Model Manipulation Methods
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context : \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {

        let categoryPredicate = NSPredicate(format: "parentCategory.title! MATCHES %@", selectedCategory!.title!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context : \(error)")
        }
        
        tableView.reloadData()
    }
}

    // MARK: Search bar methods

    extension _2DooViewController : UISearchBarDelegate {
        
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request, predicate: request.predicate!)
            
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           
            if searchBar.text?.count == 0 {
               
                loadItems()
                
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
                
            }
            
        }

    }
