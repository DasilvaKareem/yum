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
        if (FirebaseApp.app() == nil) {
            FirebaseApp.configure()
        }
        ref = Database.database().reference()

    }

    func getTrucks(completion: @escaping (_ trucks: [Truck]) -> Void) {
        var trucks: [Truck] = []
        ref.child("trucks").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots
                {
                    let truckName = snap.childSnapshot(forPath: "name").value! as! String
                    let truckCoordinateArray = snap.childSnapshot(forPath: "l").value! as! [Double]
                    let truckLocation = TruckLocation(location: truckCoordinateArray)
                    let newTruck = Truck(name: truckName, lastLocation: truckLocation, reference: self.ref)
                    print(truckName)
                    trucks.append(newTruck)
                }
                completion(trucks)
            }
        })

        completion(trucks)
    }
}
