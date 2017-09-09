//
//  MapViewController.swift
//  yum
//
//  Created by Keaton Burleson on 9/9/17.
//  Copyright © 2017 poeen. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MapKit

class MapViewController: UIViewController{
    private(set) public var truckHelper = TruckHelper()
    private(set) public var userHelper = BaseUserHelper()
    override func viewDidLoad() {
        userHelper.loginWith(email: "keaton.burleson@me.com", password: "abc123", ref: truckHelper.ref) { (loggedIn) in
            if loggedIn{
                let truckLocation = TruckLocation(latitude: 37.7853889, longitude: -122.4056973)
                let truck = Truck(name: "Yo", lastLocation: truckLocation, reference: self.truckHelper.ref)
                truck.saveTo(user: self.userHelper.currentUser!)
            }
        }
    }
    
}
