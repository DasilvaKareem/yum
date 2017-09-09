//
//  BaseUser.swift
//  yum
//
//  Created by Keaton Burleson on 9/9/17.
//  Copyright © 2017 poeen. All rights reserved.
//

import Foundation
import Firebase

class BaseUser: NSObject {
    private(set) public var ref: DatabaseReference?
    private(set) public var actualUser: User?
    private(set) public var uid: String!

    init(user: User, ref: DatabaseReference) {
        self.actualUser = user
        self.ref = ref
        self.uid = user.uid
    }

    public func fetchUserType(completion: @escaping (_ userType: BaseUserType) -> Void) {
        guard let solidReference = self.ref
            else {
                return
        }
        solidReference.child("accounts").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(self.uid) {
                solidReference.child("accounts").child(self.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    let valueDictionary = snapshot.value as? NSDictionary
                    if (valueDictionary?["food-truck"] as? Bool ?? false) == true{
                        completion(.truck)
                    } else {
                        completion(.user)
                    }
                })
            } else {
                snapshot.setValue(["food-truck": false], forKey: self.uid)
                completion(.user)
            }
        })
    }


}
enum BaseUserType: Int {
    case truck = 1
    case user = 0
}
