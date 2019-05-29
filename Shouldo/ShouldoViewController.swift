//
//  ViewController.swift
//  Shouldo
//
//  Created by woogie on 19/05/2019.
//  Copyright © 2019 Jaeuk Yun. All rights reserved.
//

import UIKit
import CoreData

class ShouldoViewController: UIViewController {
    @IBOutlet weak var addTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var shouldoList = [ShouldoEntity]()
    
    var dayOfTheWeek: String = ""
    
    var target: NSManagedObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addTextField.delegate = self
        updateFirstUI()
        shouldoList = DataManager.shared.fetchShouldo(dayOfTheWeek: dayOfTheWeek)
        self.tableView.reloadData()
    }
    
    func updateFirstUI(){
        self.title = self.dayOfTheWeek.uppercased()
        tableView.rowHeight = 75
        addTextField.returnKeyType = UIReturnKeyType(rawValue: 9)!
    }
    
    @IBAction func trashBarButtonTapped(_ sender: Any) {
        let controller = UIAlertController(title: "Delete \(dayOfTheWeek.uppercased()) Shouldos", message: "Are you sure?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .destructive) { (_) in
            let shouldos: [ShouldoEntity] = DataManager.shared.fetchShouldo(dayOfTheWeek: self.dayOfTheWeek)
            DataManager.shared.deleteShouldos(entities: shouldos)
            self.shouldoList = DataManager.shared.fetchShouldo(dayOfTheWeek: self.dayOfTheWeek)
            self.tableView.reloadData()
        }
        
        let cancleAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        
        controller.addAction(okAction)
        controller.addAction(cancleAction)
        
        present(controller, animated: true, completion: nil)
    }
    
}

extension ShouldoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shouldoList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShouldoCell", for: indexPath) as! ShouldoTableViewCell
        cell.taskLabel.text = shouldoList[indexPath.row].task
        if shouldoList[indexPath.row].isFinished == "done"{
            cell.isFinishedLabel.text = "Done!"
        } else {
            cell.isFinishedLabel.text = ""
        }
        return cell
    }
}

extension ShouldoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if dayOfTheWeek != "eve" && self.shouldoList[indexPath.row].dayOfTheWeek != "eve" {
                let shouldo = shouldoList.remove(at: indexPath.row)
                DataManager.shared.deleteShouldo(entity: shouldo)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
            } else if dayOfTheWeek == "eve" && self.shouldoList[indexPath.row].dayOfTheWeek == "eve" {
                let shouldo = shouldoList.remove(at: indexPath.row)
                DataManager.shared.deleteShouldo(entity: shouldo)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dayOfTheWeek != "eve" && self.shouldoList[indexPath.row].dayOfTheWeek != "eve"{
            if self.shouldoList[indexPath.row].isFinished == "done" {
                self.shouldoList[indexPath.row].isFinished = "no"
            } else {
                self.shouldoList[indexPath.row].isFinished = "done"
            }
        }
        target = shouldoList[indexPath.row]
        if let target = target as? ShouldoEntity {
            DataManager.shared.updateShouldo(entity: target, isFinished: target.isFinished)
            self.shouldoList = DataManager.shared.fetchShouldo(dayOfTheWeek: dayOfTheWeek)
        }
        self.tableView.reloadData()
    }
}

extension ShouldoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if addTextField.hasText {
            DataManager.shared.createShouldo(task: addTextField.text!, isFinished: "no", dayOfTheWeek: self.dayOfTheWeek){
                self.shouldoList = DataManager.shared.fetchShouldo(dayOfTheWeek: self.dayOfTheWeek)
                self.tableView.reloadData()
                self.addTextField.text = nil
            }
            
        }
        return true
    }
}
