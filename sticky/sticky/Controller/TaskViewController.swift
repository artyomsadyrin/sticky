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
import UserNotifications
import UserNotificationsUI

class TaskViewController: UIViewController, UITextFieldDelegate, UNUserNotificationCenterDelegate {
    
    
    @IBOutlet weak var taskDescription: UITextField!
    @IBOutlet weak var taskDate: UIDatePicker!
    static weak var currentList: List?
    weak var currentTask: Task?
    @IBOutlet weak var switchRemindOnDayOutlet: UISwitch!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        taskDescription.delegate = self
        taskDate.isHidden = true
        
        if let task = currentTask {
            navigationItem.title = "Details"
            taskDescription.text = task.descriptionTask
            
            if let time = task.time {
                switchRemindOnDayOutlet.isOn = true
                taskDate.isHidden = false
                taskDate.date = time as Date
            }
            else {
                taskDate.isHidden = true
            }
        }
        
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        
        completionHandler([.alert, .sound])
        
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
            taskDate.isHidden = false
        }
        else {
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
                    
                    buildNotification(taskName: taskName, taskDate: taskDate.date)
                }
                else {
                    currentTask.time = nil
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
                    
                    buildNotification(taskName: taskName, taskDate: taskDate.date)
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
    
    func buildNotification(taskName: String, taskDate: Date) {
        
        if taskDate > Date() {
            
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey:
                "\(taskName)", arguments: nil)
            
            // Deliver the notification.
            content.sound = UNNotificationSound.default()
            let nowTime = Date()
            
            let timeInterval: Double = taskDate.timeIntervalSince(nowTime)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            
            // Schedule the notification.
            let request = UNNotificationRequest(identifier: "Remind for task", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request, withCompletionHandler: nil)
            
            print("add notification")
        }
        
    }
    
}
