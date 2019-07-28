//
//  CategoryTableViewController.swift
//  2Doo
//
//  Created by Elina Lua Ming on 7/26/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        
        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categoryArray?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = categoryArray?[indexPath.row].title ?? "No categories added yet"
        
        cell.delegate = self
        
        return cell
        
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! _2DooViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
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
            let category = Category()
            category.title = textField.text!
            
            // reload table view
            self.saveCategory(with: category)
            
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
    
    func saveCategory(with category : Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context : \(error)")
        }
        
        tableView.reloadData()
        
    }

    func loadCategories() {

        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()

    }

}

// MARK: Swipe Cell Delegate methods

extension CategoryTableViewController : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            if let categoryForDeletion = self.categoryArray?[indexPath.row] {
                
                do {
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                    }
                } catch {
                    print("Error deleting category : \(error)")
                }
                            
            }
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
}
