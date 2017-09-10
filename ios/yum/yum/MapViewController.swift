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

        userHelper = (UIApplication.shared.delegate as! AppDelegate).userHelper
        mapView?.delegate = self
        mapView?.showsUserLocation = true

        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData(_:)), name: NSNotification.Name(rawValue: "loadTrucks"), object: nil)

        configureView()

        let addData = UILongPressGestureRecognizer(target: self, action: #selector(uploadTestData))
        addData.minimumPressDuration = 0.4
        self.mapView?.addGestureRecognizer(addData)

        let addTerribleData = UILongPressGestureRecognizer(target: self, action: #selector(uploadStupidTestData))
        addTerribleData.minimumPressDuration = 1.0
        self.shareButton?.addGestureRecognizer(addTerribleData)

    }


    override func viewDidAppear(_ animated: Bool) {
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        if Auth.auth().currentUser == nil {
            self.parent?.performSegue(withIdentifier: "showLogin", sender: self)
        } else {
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


    func loadData(_ notification: NSNotification) {
        let trucks = notification.userInfo?["trucks"] as! [Truck]

        DispatchQueue.main.async {
            let allAnnotations = self.mapView?.annotations
            self.mapView?.removeAnnotations(allAnnotations!)
        }

        DispatchQueue(label: "addPoints").async {
            for truck in trucks {
                self.addTruckToMap(truck: truck)
            }
        }

    }

    func addTruckToMap(truck: Truck) {
        let annotation = TruckAnnotationView()
        annotation.title = truck.name
        annotation.imageName = "yum-icon-v5.png"
        annotation.coordinate = CLLocationCoordinate2D(latitude: (truck.lastLocation?.latitude)!, longitude: (truck.lastLocation?.longitude)!)
        DispatchQueue.main.async {
            self.mapView?.addAnnotation(annotation)
        }
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
            let imageURL = faker.internet.image()
            let truckLocation = TruckLocation(latitude: (self.currentUserLocation?.coordinate.latitude)!, longitude: (self.currentUserLocation?.coordinate.longitude)!)
            let truck = Truck(name: companyName, lastLocation: truckLocation, reference: (self.truckHelper?.ref)!)
            truck.imageUrl = imageURL

            truck.saveTo(user: self.userHelper.currentUser!)
        }

    }

    @objc private func uploadTestData() {
        let latitudeFirst = (currentUserLocation?.coordinate.latitude)! + 0.0003193875648
        let longitudeFirst = (currentUserLocation?.coordinate.longitude)! + 0.0003193875648

        let latitudeSecond = latitudeFirst
        let longitudeSecond = longitudeFirst + 0.0003193875648

        let truckFirst = Truck(name: "Lets Be Frank", lastLocation: TruckLocation.init(latitude: latitudeFirst, longitude: longitudeFirst), reference: Database.database().reference())
        truckFirst.imageUrl = "https://i.imgur.com/QC3XWOW.png"

        let truckThird = Truck(name: "Bad Texas BBQ", lastLocation: TruckLocation.init(latitude: latitudeSecond, longitude: longitudeSecond), reference: Database.database().reference())
        truckThird.imageUrl = "https://i.imgur.com/I8wjeDs.png"

        DispatchQueue(label: "save").async {
            truckFirst.saveTo(user: self.userHelper.currentUser!)
        }

        DispatchQueue(label: "save").async {
            truckThird.saveTo(user: self.userHelper.currentUser!)
        }

    }


    @objc private func uploadStupidTestData() {
        DispatchQueue(label: "testDataQueue").async {
            let baseFLatitude = 35.118741
            let baseFLongitude = -89.937141



            var fLatitude = baseFLatitude
            var fLongitude = baseFLongitude
            let locale = NSLocale.current.identifier
            let faker = Faker(locale: locale)


            for _ in 0...10 {
                fLatitude = fLatitude + 0.00004387751296
                let newTruck = Truck(name: faker.company.name() + " " + faker.team.creature(), lastLocation: TruckLocation.init(latitude: fLatitude, longitude: baseFLongitude), reference: Database.database().reference())
                newTruck.imageUrl = faker.internet.image()
                newTruck.saveTo(user: self.userHelper.currentUser!)
            }
            for _ in 0...5 {
                fLongitude = fLongitude + 0.00005900859833
                let newTruck = Truck(name: faker.company.name() + " " + faker.team.creature(), lastLocation: TruckLocation.init(latitude: fLatitude, longitude: fLongitude), reference: Database.database().reference())
                newTruck.imageUrl = faker.internet.image()
                newTruck.saveTo(user: self.userHelper.currentUser!)
            }
            fLongitude = baseFLongitude
            for _ in 0...5 {
                fLongitude = fLongitude + 0.00005900859833
                let newTruck = Truck(name: faker.company.name() + " " + faker.team.creature(), lastLocation: TruckLocation.init(latitude: fLatitude - 0.0002193875648, longitude: fLongitude), reference: Database.database().reference())
                newTruck.imageUrl = faker.internet.image()
                newTruck.saveTo(user: self.userHelper.currentUser!)
            }

            let baseULongitude = fLongitude + 0.0003193875648
            var uLatitude = baseFLatitude
            for _ in 0...10 {
                uLatitude = uLatitude + 0.00004387751296
                let newTruck = Truck(name: faker.company.name() + " " + faker.team.creature(), lastLocation: TruckLocation.init(latitude: uLatitude, longitude: baseULongitude), reference: Database.database().reference())
                newTruck.imageUrl = faker.internet.image()
                newTruck.saveTo(user: self.userHelper.currentUser!)
            }

            uLatitude = baseFLatitude
            let uLongitude = baseULongitude + 0.0003193875648
            for _ in 0...10 {
                uLatitude = uLatitude + 0.00004387751296
                let newTruck = Truck(name: faker.company.name() + " " + faker.team.creature(), lastLocation: TruckLocation.init(latitude: uLatitude, longitude: uLongitude), reference: Database.database().reference())
                newTruck.imageUrl = faker.internet.image()
                newTruck.saveTo(user: self.userHelper.currentUser!)
            }

            var uBottomLongitude = fLongitude + 0.0003193875648
            let uBottomLatitude = baseFLatitude
            for _ in 0...5 {
                uBottomLongitude = uBottomLongitude + 0.00004387751296
                let newTruck = Truck(name: faker.company.name() + " " + faker.team.creature(), lastLocation: TruckLocation.init(latitude: uBottomLatitude, longitude: uBottomLongitude), reference: Database.database().reference())
                newTruck.imageUrl = faker.internet.image()
                newTruck.saveTo(user: self.userHelper.currentUser!)
            }

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
