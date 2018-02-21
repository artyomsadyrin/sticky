//
//  TaskViewController.swift
//  sticky
//
//  Created by Artsiom Sadyryn on 1/21/18.
//  Copyright © 2018 Artsiom Sadyryn. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TaskViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var taskDescription: UITextField!
    @IBOutlet weak var taskDate: UIDatePicker!
    static weak var currentList: List?
    weak var currentTask: Task?
    @IBOutlet weak var switchRemindOnDayOutlet: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskDescription.delegate = self
        
        if let task = currentTask {
            navigationItem.title = "Details"
            taskDescription.text = task.descriptionTask
        }
        
        taskDate.isEnabled = false
        taskDate.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        let isPresentingInAddTaskMode = presentingViewController is UINavigationController
        
        if isPresentingInAddTaskMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The TaskViewController is not inside a navigation controller.")
        }
        
    }
    
    @IBAction func switchRemindOnDay(_ sender: UISwitch) {
        
        if sender.isOn == true {
            taskDate.isEnabled = true
            taskDate.isHidden = false
        }
        else {
            taskDate.isEnabled = false
            taskDate.isHidden = true
        }
    }
        
        
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        
        guard let taskName = taskDescription.text, taskName.count > 0 else {
            
            let emptyField = UIAlertController(title: "Alert", message: "Task name is empty", preferredStyle: .alert)
            emptyField.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(emptyField, animated: true, completion: nil)
            return
            
        }
       
        if let currentList = TaskViewController.currentList { //записываю новый таск в БД, устанавливая связь на нужный лист
            
            if let currentTask = currentTask {
                currentTask.descriptionTask = taskName
                
                if switchRemindOnDayOutlet.isOn == true {
                    currentTask.time = taskDate.date as NSDate
                }
                
                PersistenceService.saveContext()
            }
            else {
                let task = Task(context: PersistenceService.context)
                task.descriptionTask = taskName
                task.isDone = false
                task.list = currentList
                
                if switchRemindOnDayOutlet.isOn == true {
                    task.time = taskDate.date as NSDate
                }
                
                PersistenceService.saveContext()
            }
        }
        
        let isPresentingInAddTaskMode = presentingViewController is UINavigationController
        
        if isPresentingInAddTaskMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The TaskViewController is not inside a navigation controller.")
        }
    }
 
}
