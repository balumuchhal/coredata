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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        people = core.getPeople()
        tableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    //MARK:- UDF
    //Open Dialog For Add or Edit Name
    
    func openDialog(isChange:Bool,data:PersonData = PersonData()) {
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
                self.tableView.reloadData()
            }
        }
        if isChange {
            alert.title = "TXT_EDIT_NAME".localized
            alert.message = "TXT_EDIT_A_NAME".localized
            alert.textFields?.first?.text = data.name
            saveAction = UIAlertAction(title: "TXT_EDIT".localized, style: .default) {
                [unowned self] action in
                let oldName = data.name
                data.name = alert.textFields?.first?.text ?? ""
                if oldName != data.name {
                    if !self.core.edit(person: data) {
                        data.name = oldName
                    }
                    else {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        let cancelAction = UIAlertAction(title: "TXT_CANCEL".localized, style: .cancel)
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
        openDialog(isChange: true,data: people[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

