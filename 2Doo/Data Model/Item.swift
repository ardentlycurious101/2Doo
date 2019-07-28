//
//  Item.swift
//  2Doo
//
//  Created by Elina Lua Ming on 7/27/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
