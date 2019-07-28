//
//  ViewController.swift
//  2Doo
//
//  Created by Elina Lua Ming on 7/22/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit
import RealmSwift

class _2DooViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var todoItems : Results<Item>?
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        

    }

    // MARK: TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView , cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            
            cell.textLabel?.text = "No items"
            
        }
        
        return cell
        
    }
    
    // MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status : \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // TODO: Create UIAlert dialog pop-up
        let alert = UIAlertController(title: "Add New 2Doo item", message: "", preferredStyle: .alert)
        
        // TODO: Create UIAlertAction
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        
                    }
                } catch {
                    
                    print("Error saving new items : \(error)")
                    
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "xyz"
            
            textField = alertTextField
        }
        
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: Model Manipulation Methods
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: false)

        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = todoItems?[indexPath.row] {
            
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting item : \(error)")
            }
            
        }
    }
}

    // MARK: Search bar methods

    extension _2DooViewController : UISearchBarDelegate {
        
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            
            tableView.reloadData()

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
