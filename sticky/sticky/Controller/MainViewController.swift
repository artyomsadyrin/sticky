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
        listTable.reloadData()
    }
    
    
    @IBOutlet weak var listTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTable.dataSource = self
        
        let fetchRequest: NSFetchRequest<List> = List.fetchRequest() //получаю данные из CoreData
        do {
            let listsFetched = try PersistenceService.context.fetch(fetchRequest)
            self.lists = listsFetched
            self.listTable.reloadData()
        }
        catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    var lists = [List]() //массив объектов NSManagedObject для отображения в TableView
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "ShowTasks":
            guard let listDetailViewController = segue.destination as? ListViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedListCell = sender as? ListTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let index = listTable.indexPath(for: selectedListCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedList = lists[index.row]
            listDetailViewController.list = selectedList
            
        default:
            print("Unknown segue: \(segue.identifier)")
        }
    }
    
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
        
        if editingStyle == .delete { //реализую удаление листов через свайп влево
            let list = lists[indexPath.row]
            PersistenceService.context.delete(list)

            do {
                try PersistenceService.context.save()
                listTable.reloadData()
            }
            catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    @IBAction func update(_ sender: UIBarButtonItem) {
        
        let fetchRequest: NSFetchRequest<List> = List.fetchRequest()
        do {
            let listsFetched = try PersistenceService.context.fetch(fetchRequest)
            self.lists = listsFetched
            self.listTable.reloadData()
        }
        catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

    }
    
}

