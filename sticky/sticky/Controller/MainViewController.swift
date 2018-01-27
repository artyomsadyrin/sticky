//
//  ViewController.swift
//  sticky
//
//  Created by Artsiom Sadyryn on 1/14/18.
//  Copyright © 2018 Artsiom Sadyryn. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        table.dataSource = self
        //Load a test data
        loadLists()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    var lists: [Lists] = []
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ListTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ListTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ListTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let list = lists[indexPath.row]
        
        cell.listName.text = list.name
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    private func loadLists() {
        guard let list1 = Lists(name: "Family") else {
            fatalError("Unable to instantiate list1")
        }
        
        guard let list2 = Lists(name: "Personal") else {
            fatalError("Unable to instantiate list2")
        }
        
        guard let list3 = Lists(name: "Work") else {
            fatalError("Unable to instantiate list2")
        }
        
        lists += [list1, list2, list3]
    }

}

