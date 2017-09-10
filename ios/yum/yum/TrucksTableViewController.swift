//
//  TrucksTableViewController.swift
//  yum
//
//  Created by Keaton Burleson on 9/9/17.
//  Copyright © 2017 poeen. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import Fakery
class TrucksTableViewController: UIViewController {
    public var trucks: [Truck] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var gripperView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        gripperView.layer.cornerRadius = 2.5
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData(_:)), name: NSNotification.Name(rawValue: "loadTrucks"), object: nil)

    }

    func loadData(_ notification: NSNotification) {
        let trucks = notification.userInfo?["trucks"] as! [Truck]
        self.trucks = trucks
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let destinationViewController = segue.destination as! FoodTruckDetailViewController
            destinationViewController.truck = self.trucks[(self.tableView.indexPathForSelectedRow?.row)!]
        }
    }
}
extension TrucksTableViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trucks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "truckCell")
        cell?.textLabel?.text = trucks[indexPath.row].name

        let locale = NSLocale.current.identifier
        let faker = Faker(locale: locale)
        cell?.detailTextLabel?.text = faker.team.creature()

        return cell!
    }
}
