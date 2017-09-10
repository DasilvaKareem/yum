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
    public var lastLocation: TruckLocation?
    public var name: String!
    public var key: String!
    public var imageUrl: String!
    
    private var ref: DatabaseReference!

    init(name: String, lastLocation: TruckLocation, reference: DatabaseReference, key: String) {
        super.init()
        self.name = name
        self.key = key
        self.lastLocation = lastLocation
        self.ref = reference
    }
    init(name: String, lastLocation: TruckLocation, reference: DatabaseReference) {
        super.init()
        self.name = name
        self.lastLocation = lastLocation
        self.ref = reference
    }

    public func saveTo(user: BaseUser) {
        user.fetchUserType { (userType) in
            if (userType == .truck) {
                let geoFire = GeoFire(firebaseRef: self.ref)
                let key = self.ref.childByAutoId().key
                geoFire?.setLocation(self.lastLocation?.getLocation(), forKey: key)
                self.ref.child("\(key)/name").setValue(self.name)
                self.ref.child("\(key)/image-url").setValue(self.imageUrl)
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
        self.latitude = location[0]
        self.longitude = location[1]
    }
    public func getLocation() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}
