//
//  BaseUserHelper.swift
//  yum
//
//  Created by Keaton Burleson on 9/9/17.
//  Copyright © 2017 poeen. All rights reserved.
//

import Foundation
import Firebase

class BaseUserHelper: NSObject {
    private(set) public var currentUser: BaseUser? = nil
    private(set) public var loggedIn: Bool = false
    public var currentUserType: BaseUserType? = nil

    override init() {
        if (FirebaseApp.app() == nil) {
            FirebaseApp.configure()
        }
    }
    
    func loginWith(email: String, password: String, ref: DatabaseReference, completion: @escaping (_ result: Bool) -> Void) {

        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if user != nil {
                let newUser = BaseUser(user: user!, ref: ref)
                self.setCurrentUser(user: newUser)
                self.loggedIn = true
                completion(true)
            } else {
                print(error!)
                completion(false)
            }
        }
    }

    private func setCurrentUser(user: BaseUser) {
        self.currentUser = user
    }

}
