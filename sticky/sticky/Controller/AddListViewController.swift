//
//  AddListViewController.swift
//  sticky
//
//  Created by Artsiom Sadyryn on 1/18/18.
//  Copyright © 2018 Artsiom Sadyryn. All rights reserved.
//

import Foundation
import UIKit

protocol AddListViewControllerDelegate: class {
    func refreshMainTable(_ newList: List)
}

class AddListViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var listNameTextField: UITextField!
    weak var delegate: AddListViewControllerDelegate?
    weak var currentList: List?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        listNameTextField.delegate = self
        
        if let list = currentList {
            navigationItem.title = list.name
            listNameTextField.text = list.name
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddListMode = presentingViewController is UINavigationController
        
        if isPresentingInAddListMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The AddListViewController is not inside a navigation controller.")
        }
        
    }
    
    @IBAction func saveList(_ sender: UIBarButtonItem) {
        
        guard let listName = listNameTextField.text, listName.count > 0 else {
            let emptyField = UIAlertController(title: "Alert", message: "List name is empty", preferredStyle: .alert)
            emptyField.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(emptyField, animated: true, completion: nil)
            return
        }
        
        if let currentList = currentList {
            currentList.name = listName
            PersistenceService.saveContext()
        }
        else {
            let list = List(context: PersistenceService.context)
            list.name = listName
            PersistenceService.saveContext()
        }
        
        let isPresentingInAddListMode = presentingViewController is UINavigationController
        
        if isPresentingInAddListMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The AddListViewController is not inside a navigation controller.")
        }
        
    }
    
}
