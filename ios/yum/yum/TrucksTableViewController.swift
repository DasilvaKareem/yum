//
//  TrucksTableViewController.swift
//  yum
//
//  Created by Keaton Burleson on 9/9/17.
//  Copyright © 2017 poeen. All rights reserved.
//

import Foundation
import UIKit

class TrucksTableViewController: UITableViewController {
    private(set) public var truckHelper = TruckHelper()
    private var trucks: [Truck] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        truckHelper.getTrucks { (trucks) in
            self.trucks = trucks
            self.tableView.reloadData()
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trucks.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "truckCell")
        cell?.textLabel?.text = trucks[indexPath.row].name
        return cell!
    }
    
}
