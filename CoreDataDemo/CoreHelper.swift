//
//  CoreHelper.swift
//  CoreDataDemo
//
//  Created by Elluminati on 07/01/20.
//  Copyright © 2020 swiftui learn. All rights reserved.
//

import Foundation
import CoreData
class CoreHelper {
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            }
            catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func save(name: String) -> PersonData? {
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: viewContext)!
        let person = NSManagedObject(entity: entity, insertInto: viewContext)
        person.setValue(String(Date().timeIntervalSince1970), forKeyPath: "id")
        person.setValue(name, forKey: "name")
        do {
            try viewContext.save()
            return PersonData(data: person)
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func edit(person:PersonData) -> Bool {
        let fetchRequest =  NSFetchRequest<NSManagedObject>(entityName: "Person")
        fetchRequest.predicate = NSPredicate(format: "id = %@", person.id)
        do {
            if let data = try viewContext.fetch(fetchRequest).first {
                data.setValue(person.name, forKey: "name")
                try viewContext.save()
                return true
            }
        }
        catch let error as NSError {
            print("Could not edit. \(error), \(error.userInfo)")
        }
        return false
    }
    func delete(person:PersonData) -> Bool {
        let fetchRequest =  NSFetchRequest<NSManagedObject>(entityName: "Person")
        fetchRequest.predicate = NSPredicate(format: "id = %@", person.id)
        do {
            if let data = try viewContext.fetch(fetchRequest).first {
                viewContext.delete(data)
                try viewContext.save()
                return true
            }
        }
        catch let error as NSError {
            print("Could not edit. \(error), \(error.userInfo)")
        }
        return false
    }
    func getPeople() -> [PersonData] {
        var people:[PersonData] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
            for data in try viewContext.fetch(fetchRequest) {
                people.append(PersonData(data: data))
            }
            return people
        }
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return people
        }
    }
}

class PersonData {
    var name:String!
    var id:String!
    init(data:NSManagedObject) {
        name = data.value(forKeyPath: "name") as? String ?? ""
        id = data.value(forKeyPath: "id") as? String ?? ""
    }
    init() {
        name = ""
        id = ""
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
