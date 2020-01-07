//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Elluminati on 07/01/20.
//  Copyright © 2020 swiftui learn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:- OUTLET
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- VARIABLE
    var people: [PersonData] = []
    let core = CoreHelper()
    
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title =  "TXT_THE_LIST".localized
        setTable()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK:- UDF
    func setTable() {
        self.people = self.core.getPeople()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.setTableVisibility()
    }
    //Open Dialog For Add or Edit Name

    func openDialog(isChange:Bool,indexPath:IndexPath = IndexPath(row: 0, section: 0)) {
        let alert = UIAlertController(title: "TXT_NEW_NAME".localized,
                                      message: "TXT_ADD_NEW_NAME".localized,
                                      preferredStyle: .alert)
        alert.addTextField()
        var saveAction = UIAlertAction(title: "TXT_SAVE".localized, style: .default) {
            [unowned self] action in
            guard let textField = alert.textFields?.first, let nameToSave = textField.text else {
                return
            }
            if let person = self.core.save(name: nameToSave) {
                self.people.append(person)
                self.tableView.beginUpdates()
                let indexPath = IndexPath(row: self.people.count-1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                let cell = self.tableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = person.name
                self.tableView.endUpdates()
                self.setTableVisibility()
            }
        }
        var cancelAction = UIAlertAction(title: "TXT_CANCEL".localized, style: .cancel)
        if isChange {
            alert.title = "TXT_EDIT_NAME".localized
            alert.message = "TXT_EDIT_A_NAME".localized
            let data = people[indexPath.row]
            alert.textFields?.first?.text = data.name
            saveAction = UIAlertAction(title: "TXT_EDIT".localized, style: .default) {
                [unowned self] action in
                self.tableView.deselectRow(at: indexPath, animated: true)
                let oldName = data.name
                data.name = alert.textFields?.first?.text ?? ""
                if oldName != data.name {
                    if !self.core.edit(person: data) {
                        data.name = oldName
                    }
                    else {
                        self.tableView.beginUpdates()
                        let cell = self.tableView.cellForRow(at: indexPath)
                        cell?.textLabel?.text =  data.name
                        self.tableView.endUpdates()
                    }
                }
            }
            cancelAction = UIAlertAction(title: "TXT_CANCEL".localized, style: .cancel) { [unowned self] action in
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    //MARK:- ACTION
    @IBAction func addName(_ sender: UIBarButtonItem) {
        openDialog(isChange: false)
    }
}

//MARK: - UITableViewDataSource,UITableViewDelegate
extension ViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = people[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDialog(isChange: true,indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if core.delete(person: people[indexPath.row]) {
                people.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .none)
                tableView.endUpdates()
                setTableVisibility()
            }
        }
    }
    
    func setTableVisibility() {
        tableView.isHidden = !(people.count > 0)
    }
}

