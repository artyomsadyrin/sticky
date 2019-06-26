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
    
    private var tasks = [Task]()
    weak var list: List?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        taskTable.dataSource = self
        
        if let list = list {
            navigationItem.title = list.name
        }
        updateTasksTable()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTasksTable()
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "ShowTaskDetail":
            guard let taskDetailViewController = segue.destination as? TaskViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedTaskCell = sender as? TaskTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = taskTable.indexPath(for: selectedTaskCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedTask = tasks[indexPath.row]
            taskDetailViewController.currentTask = selectedTask //отправляю NSManagedObject в TaskVC
            taskDetailViewController.currentList = list
            
        case "AddTask":
            guard let taskDetailViewController = segue.destination.contents as? TaskViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            taskDetailViewController.currentList = list
        default:
            print("Unknown segue: \(String(describing: segue.identifier))")
        }
        
    }
    
    func updateTasksTable() { //метод, который получает из БД все невыполненные таски, добавленный на данный момент, и записывает их в массив tasks
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            let gettingTasks = try PersistenceService.context.fetch(fetchRequest)
            var tempTasks = [Task]()
            
            for task in gettingTasks { //получаю все таски по выбранному листу
                if task.list?.objectID == list?.objectID && task.isDone == false {
                    tempTasks.append(task)
                }
            }
            
            tasks = tempTasks
            taskTable.reloadData()
        }
        catch {
            fatalError("Can't get tasks.")
        }
        
    }
    
    func updateTaskTableWithDoneTask() {
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            let gettingTasks = try PersistenceService.context.fetch(fetchRequest)
            var tempTasks = [Task]()
            
            for task in gettingTasks { //получаю все таски по выбранному листу
                if task.list?.objectID == list?.objectID && task.isDone == true {
                    tempTasks.append(task)
                }
            }
            
            tasks = tempTasks
            taskTable.reloadData()
        }
        catch {
            fatalError("Can't get tasks.")
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "TaskTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TaskTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ListTableViewCell.")
        }
        
        let task = tasks[indexPath.row]
        cell.taskName.text = task.descriptionTask
        
        if let taskDate = task.time as Date? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy hh:mm a"
            let stringDate = dateFormatter.string(from: taskDate) //делаю дату, полученную из БД, в нужном формате
            cell.taskDate.text = stringDate
            
            if taskDate < Date() { //проверяю истек ли срок выполнения таска
                cell.taskDate.textColor = .red
            }
        }
        else {
            cell.taskDate.isHidden = true
        }
        
        return cell

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete { //реализую удаление листов через свайп влево
            let task = tasks[indexPath.row]
            PersistenceService.context.delete(task)
            
            if task.isDone == true {
                updateTaskTableWithDoneTask()
            }
            else {
                updateTasksTable()
            }
            
            do {
                try PersistenceService.context.save()
            }
            catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
    }
    
    @IBAction func taskIsDone(_ sender: UIButton) {
        
        guard let selectedTaskCell = sender.superview?.superview as? TaskTableViewCell else {
            fatalError("Unexpected sender: \(sender)")
        }
        
        guard let index = taskTable.indexPath(for: selectedTaskCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        let selectedTask = tasks[index.row]
        
        if selectedTask.isDone == false {
            
            selectedTask.isDone = true
            PersistenceService.saveContext()
            
            tasks.remove(at: index.row)
            taskTable.deleteRows(at: [index], with: .fade)
            
        }
        else {
            selectedTask.isDone = false
            PersistenceService.saveContext()
                        
            tasks.remove(at: index.row)
            taskTable.deleteRows(at: [index], with: .fade)
        }
        
    }
    
    
    @IBAction func getDoneTasks(_ sender: UIBarButtonItem) {
        updateTaskTableWithDoneTask()
    }
    
    
}

extension UIViewController {
    // Property для получения ViewController, когда перед ViewController стоит NavigationController
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            // Если перед нами NavigationController, то возвращается ViewController, в который идет переход через NavigationController
            return navcon.visibleViewController ?? self
        } else {
            // Если перед нами ViewController, то возвращается self
            return self
        }
    }
}
