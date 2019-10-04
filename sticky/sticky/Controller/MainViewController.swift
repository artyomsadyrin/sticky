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

class MainViewController: UIViewController, UITableViewDataSource, UISplitViewControllerDelegate {
    
    @IBOutlet weak var listTable: UITableView!
    private var lists = [List]() //массив объектов NSManagedObject для отображения в TableView
    private let listsRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTable.dataSource = self
        listTable.refreshControl = listsRefreshControl
        listsRefreshControl.addTarget(self, action: #selector(updateListsTableView(_:)), for: .valueChanged)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    func updateListTable() {

        let fetchRequest: NSFetchRequest<List> = List.fetchRequest()
        do {
            let listsFetched = try PersistenceService.context.fetch(fetchRequest)
            self.lists = listsFetched
            self.listTable.reloadData()
            print("Updated")
        }
        catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let listVC = secondaryViewController.contents as? ListViewController {
            if listVC.list == nil {
                return true
            }
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "ShowTasks":
            guard let listDetailViewController = segue.destination.contents as? ListViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedListCell = sender as? ListTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let index = listTable.indexPath(for: selectedListCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedList = lists[index.row]
            listDetailViewController.list = selectedList
            
        case "ShowListDetail":
            guard let addListViewController = segue.destination.contents as? AddListViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedListCell = sender as? ListTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let index = listTable.indexPath(for: selectedListCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedList = lists[index.row]
            addListViewController.currentList = selectedList
            
        default:
            print("Unknown segue: \(String(describing: segue.identifier))")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateListTable()
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
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete { //реализую удаление листов через свайп влево
            let list = lists[indexPath.row]
            PersistenceService.context.delete(list)
            
            do {
                try PersistenceService.context.save()
                updateListTable()
            }
            catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
    }
    
    @objc func updateListsTableView(_ sender: Any) {
        updateListTable()
        listsRefreshControl.endRefreshing()
        print("Refreshed")
    }
    
}

