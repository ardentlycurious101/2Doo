//
//  ViewController.swift
//  2Doo
//
//  Created by Elina Lua Ming on 7/22/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

class _2DooViewController: UITableViewController {

    let itemArray = ["Brian Dionigi", "Nabila Nizam", "Jose Cruz"]
    override func viewDidLoad() {
        super.viewDidLoad()
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
}

