//
//  ViewController.swift
//  sticky
//
//  Created by Artsiom Sadyryn on 1/14/18.
//  Copyright © 2018 Artsiom Sadyryn. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDataSource, AddListViewControllerDelegate {
    
    func refreshMainTable(_ newList: List) {
        lists.append(newList)
        table.reloadData()
    }
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        
        let fetchRequest: NSFetchRequest<List> = List.fetchRequest()
        do {
            let listsFetched = try PersistenceService.context.fetch(fetchRequest)
            self.lists = listsFetched
            self.table.reloadData()
        }
        catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    var lists = [List]()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ListTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ListTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ListTableViewCell.")
        }
        
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let list = lists[indexPath.row]
            PersistenceService.context.delete(list)

            do {
                try PersistenceService.context.save()
                tableView.reloadData()
            }
            catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    @IBAction func update(_ sender: UIBarButtonItem) {
        
        table.reloadData()
    }
    

}

