//
//  TruckHelper.swift
//  yum
//
//  Created by Keaton Burleson on 9/8/17.
//  Copyright © 2017 poeen. All rights reserved.
//

import Foundation
import Firebase

class TruckHelper: NSObject {
    private(set) public var query: DatabaseQuery?
    private(set) public var ref: DatabaseReference!

    override init() {
        FirebaseApp.configure()
        ref = Database.database().reference()
        query = self.ref.child("trucks").queryOrdered(byChild: "name")
    }
    func getTrucks() -> [Int: Truck] {
        guard let query = self.query
            else {
                return [:]
        }
        query.observe(.value, with: { (snapshot) in
            for truck in snapshot.children {
                let newTruck = Truck(name: truck["name"], lastLocation: <#TruckLocation#>)
                
            }
        })
        return [:]
    }
}
