//
//  SearchViewController.swift
//  Shouldo
//
//  Created by woogie on 23/05/2019.
//  Copyright © 2019 Jaeuk Yun. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {

    var data = [ShouldoEntity]()
    var result = [ShouldoEntity]()
    var target: NSManagedObject?
    
    var searchActive: Bool = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 75
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        data = DataManager.shared.fetchSearchTotal()
    }

}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return result.count
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchTableViewCell
        if searchActive {
            cell.taskLabel?.text = result[indexPath.row].task
            if result[indexPath.row].isFinished == "done"{
                cell.isFinishedLabel?.text = "Done!"
            } else {
                cell.isFinishedLabel?.text = ""
            }
        } else {
            cell.taskLabel?.text = data[indexPath.row].task
            if data[indexPath.row].isFinished == "done"{
                cell.isFinishedLabel?.text = "Done!"
            } else {
                cell.isFinishedLabel?.text = ""
            }
        }
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if searchActive {
                let delete = result.remove(at: indexPath.row)
                DataManager.shared.deleteShouldo(entity: delete)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
            } else {
                let delete = data.remove(at: indexPath.row)
                DataManager.shared.deleteShouldo(entity: delete)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchActive {
            if self.result[indexPath.row].isFinished == "done" {
                self.result[indexPath.row].isFinished = "no"
            } else {
                self.result[indexPath.row].isFinished = "done"
            }
            self.target = result[indexPath.row]
            if let target = target as? ShouldoEntity {
                DataManager.shared.updateShouldo(entity: target, isFinished: target.isFinished)
                data = DataManager.shared.fetchSearchTotal()
            }
            self.tableView.reloadData()
        } else {
            if self.data[indexPath.row].isFinished == "done" {
                self.data[indexPath.row].isFinished = "no"
            } else {
                self.data[indexPath.row].isFinished = "done"
            }
            self.target = data[indexPath.row]
            if let target = target as? ShouldoEntity {
                DataManager.shared.updateShouldo(entity: target, isFinished: target.isFinished)
                data = DataManager.shared.fetchSearchTotal()
            }
            self.tableView.reloadData()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        result = data.filter({ (shouldoEntity) -> Bool in
            let tmp: NSString = shouldoEntity.task! as NSString
            let range = tmp.range(of: searchText, options: .caseInsensitive)
            return range.location != NSNotFound
        })
        
        if result.count == 0 {
            searchActive = false
        } else {
            searchActive = true
        }
        self.tableView.reloadData()
    }
}
