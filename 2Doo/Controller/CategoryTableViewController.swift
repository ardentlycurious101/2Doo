//
//  CategoryTableViewController.swift
//  2Doo
//
//  Created by Elina Lua Ming on 7/26/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categoryArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].title
        
        return cell
        
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! _2DooViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    // MARK: - Add categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // create alert
        let alert = UIAlertController(title: "Add new categories", message: "", preferredStyle: .alert)
        
        // create action
        let action = UIAlertAction(title: "Add categories", style: .default) { (action) in
            
            // create category
            let category = Category(context: self.context)
            
            category.title = textField.text!
            
            // append category to categoryArray
            self.categoryArray.append(category)
            
            // reload table view
            self.saveCategory()
            
        }
        
        // attach alert text field
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "abc"
            textField = alertTextField
        }
        
        // attach alert action
        alert.addAction(action)
        
        // present 
        present(alert, animated: true, completion: nil)
        
        
    }
    
    // MARK: Data manipulation
    
    func saveCategory() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context : \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching request : \(error)")
        }
        
        tableView.reloadData()
        
    }
    
}
