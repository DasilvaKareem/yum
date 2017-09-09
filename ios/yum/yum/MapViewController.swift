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
import Fakery

class MapViewController: UIViewController{
    private(set) public var truckHelper = TruckHelper()
    private(set) public var userHelper = BaseUserHelper()

    private var locationManager: CLLocationManager?
    
    public var currentUserLocation: CLLocation? = nil
    @IBOutlet public var shareButton: UIButton?
    
    override func viewDidLoad() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        configureView()
        userHelper.loginWith(email: "keaton.burleson@me.com", password: "abc123", ref: truckHelper.ref) { (loggedIn) in
            if loggedIn{
                self.userHelper.currentUser?.fetchUserType(completion: { (userType) in
                    if userType == .truck{
                        self.shareButton?.alpha = 0.0
                        self.shareButton?.isHidden = false
                        UIView.animate(withDuration: 0.3, animations: { 
                            self.shareButton?.alpha = 1.0
                        })
                    }
                })
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    func configureView(){
        shareButton?.isHidden = true
        shareButton?.layer.cornerRadius = 12
    }
    
    @IBAction func shareTruckLocation(sender: UIButton){
        if userHelper.loggedIn == true && self.currentUserLocation != nil{
            let locale = NSLocale.current.identifier
            let faker = Faker(locale: locale)
            let companyName = faker.company.name() + " " + faker.team.creature()
            let truckLocation = TruckLocation(latitude: (self.currentUserLocation?.coordinate.latitude)!, longitude: (self.currentUserLocation?.coordinate.longitude)!)
            let truck = Truck(name: companyName, lastLocation: truckLocation, reference: self.truckHelper.ref)
            truck.saveTo(user: self.userHelper.currentUser!)
        }
        
    }
}
extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentUserLocation = locations.last
        print("location updated")
    }
}
