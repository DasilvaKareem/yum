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
        if (FirebaseApp.app() == nil){
            FirebaseApp.configure()
        }
        ref = Database.database().reference()
        query = self.ref.child("trucks")
    }

    func getTrucks(completion: @escaping (_ trucks: [Truck]) -> Void) {
        var trucks: [Truck] = []
        guard let query = self.query
            else {
                completion(trucks)
                return
        }
        query.observe(.value, with: { (snapshot) in
            for truck in snapshot.children {
                
                
                let truckDictionary = snapshot.childSnapshot(forPath: (truck as AnyObject).key).value as! [String: AnyObject]
                let locationDictionary = truckDictionary["l"] as! [Double]
                let truckLocation = TruckLocation(latitude: locationDictionary[0], longitude: locationDictionary[1])

                let newTruck = Truck(name: truckDictionary["name"] as! String, lastLocation: truckLocation, reference: self.ref)
                trucks.append(newTruck)
            }
        })
        completion(trucks)
    }
}
