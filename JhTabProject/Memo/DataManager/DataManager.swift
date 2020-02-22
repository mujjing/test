//
//  DataManager.swift
//  JhTabProject
//
//  Created by Jh's MacbookPro on 2019/12/22.
//  Copyright © 2019 JH. All rights reserved.
//

import Foundation
import CoreData

class DataManager{
    
    static let shared = DataManager()
    private init(){
        
    }
    var mainContext: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    var memoList = [Memo]()
    
    func fetchMemo(){
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        
        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        
        request.sortDescriptors = [sortByDateDesc]
        
        do {
            memoList = try mainContext.fetch(request)
        } catch  {
            print(error)
        }
    }
    
    func addNewMemo(_ memo: String?){
        let newMemo = Memo(context: mainContext)
        newMemo.content = memo
        newMemo.insertDate = Date()
        
        memoList.insert(newMemo, at: 0)
        
        saveContext()
    }
    
    func deleteMemo(_ memo: Memo?){
        if let memo = memo{
            mainContext.delete(memo)
            saveContext()
        }
    }
    
    // MARK: - Core Data stack

       lazy var persistentContainer: NSPersistentContainer = {
           /*
            The persistent container for the application. This implementation
            creates and returns a container, having loaded the store for the
            application to it. This property is optional since there are legitimate
            error conditions that could cause the creation of the store to fail.
           */
           let container = NSPersistentContainer(name: "JhTabProject")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                   // Replace this implementation with code to handle the error appropriately.
                   // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                   /*
                    Typical reasons for an error here include:
                    * The parent directory does not exist, cannot be created, or disallows writing.
                    * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                    * The device is out of space.
                    * The store could not be migrated to the current model version.
                    Check the error message to determine what the actual problem was.
                    */
                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
           })
           return container
       }()

       // MARK: - Core Data Saving support

       func saveContext () {
           let context = persistentContainer.viewContext
           if context.hasChanges {
               do {
                   try context.save()
               } catch {
                   // Replace this implementation with code to handle the error appropriately.
                   // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                   let nserror = error as NSError
                   fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               }
           }
       }
}
