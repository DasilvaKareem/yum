//
//  Truck.swift
//  yum
//
//  Created by Keaton Burleson on 9/8/17.
//  Copyright © 2017 poeen. All rights reserved.
//

import Foundation

class Truck: NSObject{
    private(set) public var lastLocation: TruckLocation?
    private(set) public var name: String?
    init(name: String, lastLocation: TruckLocation){
        super.init()
        self.name = name
        self.lastLocation = lastLocation
    }
}

class TruckLocation: NSObject{
    public var address: String!
    public var zipCode: String?
    public var state: String?
    public var country: String!
    init(address: String, zipCode: String, state: String, country: String){
        super.init()
        self.address = address
        self.zipCode = zipCode
        self.state = state
        self.country = country
    }
}
