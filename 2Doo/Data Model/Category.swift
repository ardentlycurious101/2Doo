//
//  Category.swift
//  2Doo
//
//  Created by Elina Lua Ming on 7/27/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var title : String = ""
    let items = List<Item>()
    
}
