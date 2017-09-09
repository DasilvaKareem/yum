//
//  TruckHelper.swift
//  yum
//
//  Created by Keaton Burleson on 9/8/17.
//  Copyright © 2017 poeen. All rights reserved.
//

import Foundation
import Firebase

class TruckHelper: NSObject{
    private(set) public var query: DatabaseQuery?
    private(set) public var ref: DatabaseReference!
    
    override init() {
        ref = Database.database().reference()
        query = self.ref.child("Trucks").queryOrdered(byChild: "name")
    }
    func getTrucks() -> [Int: Truck]{
        let testQuery = query!
        return [:]
    }
}
