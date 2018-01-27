//
//  ListViewController.swift
//  sticky
//
//  Created by Artsiom Sadyryn on 1/21/18.
//  Copyright © 2018 Artsiom Sadyryn. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableOfTasks: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableOfTasks.dataSource = self
        loadTasks()
    }
    
    var tasks: [Tasks] = []
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "TaskTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TaskTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ListTableViewCell.")
        }
        
        let task = tasks[indexPath.row]
        
        cell.descriptionTask.text = task.descriptionTask
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    private func loadTasks() {
        guard let task1 = Tasks(description: "Clean room") else {
            fatalError("Unable to instantiate list1")
        }
        
        guard let task2 = Tasks(description: "Wash dishes") else {
            fatalError("Unable to instantiate list2")
        }
        
        guard let task3 = Tasks(description: "Take out trash") else {
            fatalError("Unable to instantiate list2")
        }
        
        tasks += [task1, task2, task3]
    }
    
}
