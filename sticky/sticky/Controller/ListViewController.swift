//
//  ListViewController.swift
//  sticky
//
//  Created by Artsiom Sadyryn on 1/21/18.
//  Copyright © 2018 Artsiom Sadyryn. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var taskTable: UITableView!
    
    var tasks = [Task]()
    weak var list: List?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTable.dataSource = self
        
        if let list = list {
            navigationItem.title = list.name
            if let currentTasks = list.task, let tasksArr = Array(currentTasks) as? [Task] {
                tasks = tasksArr
            }
            TaskViewController.currentList = list
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTasksTable()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        
    }
 
    func updateTasksTable() {
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "TaskTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TaskTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ListTableViewCell.")
        }
        
        let task = tasks[indexPath.row]
        
        cell.taskName.text = task.descriptionTask
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete { //реализую удаление листов через свайп влево
            let task = tasks[indexPath.row]
            PersistenceService.context.delete(task)
            
            do {
                try PersistenceService.context.save()
                updateTasksTable()
            }
            catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    @IBAction func updateByClick(_ sender: UIBarButtonItem) {
        updateTasksTable()
    }
    
    
}
