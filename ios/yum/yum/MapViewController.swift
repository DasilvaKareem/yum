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

class MapViewController: UIViewController {
    private(set) public var truckHelper = TruckHelper()
    private(set) public var userHelper = BaseUserHelper()

    private var locationManager: CLLocationManager?

    public var currentUserLocation: CLLocation? = nil

    @IBOutlet public var shareButton: UIButton?
    @IBOutlet public var mapView: MKMapView?

    override func viewDidLoad() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest

        mapView?.delegate = self
        mapView?.showsUserLocation = true

        configureView()
        userHelper.loginWith(email: "keaton.burleson@me.com", password: "abc123", ref: truckHelper.ref) { (loggedIn) in
            if loggedIn {
                self.userHelper.currentUser?.fetchUserType(completion: { (userType) in
                    if userType == .truck {
                        self.shareButton?.alpha = 0.0
                        self.shareButton?.isHidden = false
                        UIView.animate(withDuration: 0.3, animations: {
                            self.shareButton?.alpha = 1.0
                        })
                    }
                })
            }
        }
        
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(manuallyGetTrucks))
        tapGesture.minimumPressDuration = 0.5
        self.mapView?.addGestureRecognizer(tapGesture)
    }
    
    func manuallyGetTrucks(){
        if self.currentUserLocation != nil{
            truckHelper.getTrucks(currentLocation:  self.currentUserLocation!) { (trucks) in
                let trucksDict: [String: [Truck]] = ["trucks": trucks]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTrucks"), object: nil, userInfo: trucksDict)
                for truck in trucks {
                    self.addTruckToMap(truck: truck)
                }
            }
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }

    func addTruckToMap(truck: Truck) {
        let annotation = MKPointAnnotation()
        annotation.title = truck.name
        annotation.coordinate = CLLocationCoordinate2D(latitude: (truck.lastLocation?.latitude)!, longitude: (truck.lastLocation?.longitude)!)
        self.mapView?.addAnnotation(annotation)
    }
    func configureView() {
        shareButton?.isHidden = true
        shareButton?.layer.cornerRadius = 12
    }

    @IBAction func shareTruckLocation(sender: UIButton) {
        if userHelper.loggedIn == true && self.currentUserLocation != nil {
            let locale = NSLocale.current.identifier
            let faker = Faker(locale: locale)
            let companyName = faker.company.name() + " " + faker.team.creature()
            let truckLocation = TruckLocation(latitude: (self.currentUserLocation?.coordinate.latitude)!, longitude: (self.currentUserLocation?.coordinate.longitude)!)
            let truck = Truck(name: companyName, lastLocation: truckLocation, reference: self.truckHelper.ref)
            truck.saveTo(user: self.userHelper.currentUser!)
        }

    }
}
extension MapViewController: MKMapViewDelegate {

}
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.currentUserLocation == nil{
            truckHelper.getTrucks(currentLocation:  locations.last!) { (trucks) in
                let trucksDict: [String: [Truck]] = ["trucks": trucks]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadTrucks"), object: nil, userInfo: trucksDict)
                for truck in trucks {
                    self.addTruckToMap(truck: truck)
                }
            }
        }
        self.currentUserLocation = locations.last
        let span = MKCoordinateSpanMake(0.04, 0.04)
        let region = MKCoordinateRegion(center: (currentUserLocation?.coordinate)!, span: span)
        self.mapView?.setRegion(region, animated: true)

        


    }
}
