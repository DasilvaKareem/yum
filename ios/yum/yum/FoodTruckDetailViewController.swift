//
//  MapDetailViewController.swift
//  yum
//
//  Created by Keaton Burleson on 9/9/17.
//  Copyright © 2017 poeen. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
class FoodTruckDetailViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var mapView: MKMapView?
    @IBOutlet var imageView: UIImageView?
    @IBOutlet var doneButton: UIButton?

    public var truck: Truck? = nil {
        didSet {
            self.title = truck?.name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setMapSpan()
        dropPin()
    }

    func setMapSpan() {
        let coordinate = CLLocationCoordinate2D(latitude: (truck?.lastLocation?.latitude)!, longitude: (truck?.lastLocation?.longitude)!)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.mapView?.setRegion(region, animated: true)
    }

    func configureView() {
        self.mapView?.layer.cornerRadius = 12
        self.titleLabel?.text = truck?.name
        self.titleLabel?.sizeToFit()
        print(URL(string: (truck?.imageUrl!)!)!)
        if truck?.imageUrl != nil {
            imageView?.kf.indicatorType = .activity
            imageView?.kf.setImage(with: URL(string: (truck?.imageUrl)!))
        }
        doneButton?.layer.cornerRadius = 12
    }
    
    func dropPin(){
        let annotation = MKPointAnnotation()
        annotation.title = truck?.name
        annotation.coordinate = CLLocationCoordinate2D(latitude: (truck?.lastLocation?.latitude)!, longitude: (truck?.lastLocation?.longitude)!)
        self.mapView?.addAnnotation(annotation)
    }

    @IBAction func backAction(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
