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
    public var truckHelper: TruckHelper? = nil
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

        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData(_:)), name: NSNotification.Name(rawValue: "loadTrucks"), object: nil)

        configureView()
        userHelper.loginWith(email: "keaton.burleson@me.com", password: "abc123", ref: Database.database().reference()) { (loggedIn) in
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
    }

    override func viewDidAppear(_ animated: Bool) {
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }


    func loadData(_ notification: NSNotification) {
        let trucks = notification.userInfo?["trucks"] as! [Truck]

        let allAnnotations = self.mapView?.annotations
        self.mapView?.removeAnnotations(allAnnotations!)

        for truck in trucks {
            addTruckToMap(truck: truck)
        }

    }

    func addTruckToMap(truck: Truck) {
        let annotation = TruckAnnotationView()
        annotation.title = truck.name
        annotation.imageName = "yum-annotate.png"
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
            let truck = Truck(name: companyName, lastLocation: truckLocation, reference: (self.truckHelper?.ref)!)
            truck.saveTo(user: self.userHelper.currentUser!)
        }

    }
}
extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is TruckAnnotationView) {
            return nil
        }

        let reuseId = "truckAnnotation"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView?.canShowCallout = true
        }
            else {
                annotationView?.annotation = annotation
        }


        let truckAnnotation = annotation as! TruckAnnotationView
        annotationView?.image = UIImage(named: truckAnnotation.imageName)


        return annotationView
    }

}
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.currentUserLocation == nil {
            self.currentUserLocation = locations.last
            truckHelper = TruckHelper(currentLocation: locations.last!)
            let span = MKCoordinateSpanMake(0.002, 0.002)
            let region = MKCoordinateRegion(center: (currentUserLocation?.coordinate)!, span: span)
            self.mapView?.setRegion(region, animated: true)

        }
        self.currentUserLocation = locations.last

    }

}
