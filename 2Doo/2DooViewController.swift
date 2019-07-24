//
//  ViewController.swift
//  2Doo
//
//  Created by Elina Lua Ming on 7/22/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

class _2DooViewController: UITableViewController {

    var itemArray = ["Brian Dionigi", "Nabila Nizam", "Jose Cruz"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemArray = defaults.array(forKey: "2DooListArray") as! [String]
    }

    // MARK: TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "2DooItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    // MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // TODO: Create UIAlert dialog pop-up
        let alert = UIAlertController(title: "Add New 2Doo item", message: "", preferredStyle: .alert)
        
        // TODO: Create UIAlertAction
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the Add Item button on our UIAlert
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: "2DooListArray")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "xyz"
            textField = alertTextField
        }
        
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
        
    }
    
}
