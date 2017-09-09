//
//  Truck.swift
//  yum
//
//  Created by Keaton Burleson on 9/8/17.
//  Copyright © 2017 poeen. All rights reserved.
//

import Foundation
import Firebase

class Truck: NSObject {
    private(set) public var lastLocation: TruckLocation?
    private(set) public var name: String!
    private var ref: DatabaseReference!

    init(name: String, lastLocation: TruckLocation, reference: DatabaseReference) {
        super.init()
        self.name = name
        self.lastLocation = lastLocation
        self.ref = reference
    }

    public func saveTo(user: BaseUser) {
        user.fetchUserType { (userType) in
            if (userType == .truck) {
                let geoFire = GeoFire(firebaseRef: self.ref?.child("trucks"))
                let key = self.ref.childByAutoId().key
                geoFire?.setLocation(self.lastLocation?.getLocation(), forKey: key)
                self.ref.child("trucks/\(key)/name").setValue("Yo12")
            } else {
                print("Cannot create truck, account not truck account")
            }
        }
    }
}

class TruckLocation: NSObject {
    public var latitude: Double!
    public var longitude: Double!
    init(latitude: Double, longitude: Double) {
        super.init()
        self.latitude = latitude
        self.longitude = longitude
    }
    init(location: [Double]){
        
    }
    public func getLocation() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}
