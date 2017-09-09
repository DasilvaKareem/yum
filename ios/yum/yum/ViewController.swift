//
//  ViewController.swift
//  yum
//
//  Created by Kareem Dasilva on 9/8/17.
//  Copyright © 2017 poeen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var truckData: [String: AnyObject] = [:]
    var truckHelper = TruckHelper()
    
    override func viewDidLoad() {
        let _ = self.truckHelper.getTrucks()
    
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

