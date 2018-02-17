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

class TaskViewController: UIViewController {
    
    @IBOutlet weak var descriptionTaskTextField: UITextField!
    @IBOutlet weak var dateCompletion: UIDatePicker!
    static weak var currentList: List?
    @IBOutlet weak var saveTaskButton: UIBarButtonItem!
    @IBOutlet weak var note: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        let isPresentingInAddListMode = presentingViewController is UINavigationController
        
        if isPresentingInAddListMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The TaskViewController is not inside a navigation controller.")
        }
        
    }
    
        
        
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        
        guard let taskName = descriptionTaskTextField.text, taskName.count > 0 else {
            
            let emptyField = UIAlertController(title: "Alert", message: "List name is empty", preferredStyle: .alert)
            emptyField.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(emptyField, animated: true, completion: nil)
            return
            
        }
       
        if let currentList = TaskViewController.currentList {
            let task = Task(context: PersistenceService.context)
            task.descriptionTask = taskName
            task.list = currentList
            PersistenceService.saveContext()
        }
        dismiss(animated: true, completion: nil)
    }
 
}
