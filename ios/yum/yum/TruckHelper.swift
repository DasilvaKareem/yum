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

    func getTrucks(currentLocation: CLLocation, completion: @escaping (_ trucks: [Truck]) -> Void) {
        var trucks: [Truck] = []
        let geoFire = GeoFire(firebaseRef: ref)
        let query = geoFire?.query(at: currentLocation, withRadius: 0.6)

        query?.observe(.keyEntered, with: { (key: String?, location: CLLocation?) in
            print("key entered")
            self.ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let snapshot = snapshot.childSnapshot(forPath: key!)
                let truckName = snapshot.childSnapshot(forPath: "name").value! as! String
                let truckCoordinateArray = snapshot.childSnapshot(forPath: "l").value! as! [Double]
                let truckLocation = TruckLocation(location: truckCoordinateArray)
                let newTruck = Truck(name: truckName, lastLocation: truckLocation, reference: self.ref)
                print(truckName)
                trucks.append(newTruck)
                
                 completion(trucks)
            })
        })

    }
}
