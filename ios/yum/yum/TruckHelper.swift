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
    private(set) public var trucks: [Truck]? = []
    public var currentLocation: CLLocation? = nil

    init(currentLocation: CLLocation) {
        super.init()
        self.currentLocation = currentLocation
        ref = Database.database().reference()

        let geoFire = GeoFire(firebaseRef: ref)
        let query = geoFire?.query(at: currentLocation, withRadius: 0.6)
        query?.observe(.keyExited, with: { (key: String?, location: CLLocation?) in
            print("key exited")
            self.ref.observeSingleEvent(of: .value, with: { (snapshot) in
                self.removeTruck(key: key!)
            })
        })

        query?.observe(.keyEntered, with: { (key: String?, location: CLLocation?) in
            print("key entered")
            self.ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let snapshot = snapshot.childSnapshot(forPath: key!)
                let truckName = snapshot.childSnapshot(forPath: "name").value! as! String
                let truckCoordinateArray = snapshot.childSnapshot(forPath: "l").value! as! [Double]
                let truckLocation = TruckLocation(location: truckCoordinateArray)

                let newTruck = Truck(name: truckName, lastLocation: truckLocation, reference: self.ref, key: key!)
                newTruck.imageUrl = snapshot.childSnapshot(forPath: "image-url").value as! String
                self.addTruck(truck: newTruck)

            })
        })



    }

    func removeTruck(key: String) {
        if let index = self.trucks?.index(where: { $0.key == key }) {
            self.trucks?.remove(at: index)
        }
        updateSubscribers()
    }
    
    func addTruck(truck: Truck) {
        self.trucks?.append(truck)
        updateSubscribers()
    }

    private func updateSubscribers() {
        let trucksDict: [String: [Truck]] = ["trucks": trucks!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTrucks"), object: nil, userInfo: trucksDict)
    }


}

