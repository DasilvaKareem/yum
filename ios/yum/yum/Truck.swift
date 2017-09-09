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
}

class TruckLocation: NSObject{
    public var address: String!
    public var zipCode: String?
    public var state: String?
    public var country: String!
}
