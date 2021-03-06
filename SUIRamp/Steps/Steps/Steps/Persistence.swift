//
//  Persistence.swift
//  Steps
//
//  Created by Luke Solomon on 12/23/20.
//

import CoreData
import HealthKit

class PersistenceController {
  static let shared = PersistenceController()
  
  static var preview: PersistenceController = {
    let result = PersistenceController(inMemory: true)
    let viewContext = result.container.viewContext
    for _ in 0..<10 {
      let newSteps = Steps(context: viewContext)
      newSteps.count = Int64(Int.random(in: 2000...10000))
      newSteps.date = Date()
      //      newSteps.timestamp = Date()
    }
    do {
      try viewContext.save()
    } catch {
      // Replace this implementation with code to handle the error appropriately.
      // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
    return result
  }()
  
  lazy var operationQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    return queue
  }()
  
  let container: NSPersistentCloudKitContainer
  
  init(inMemory: Bool = false) {
    container = NSPersistentCloudKitContainer(name: "Steps")
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }
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
    
    container.viewContext.automaticallyMergesChangesFromParent = true
    container.viewContext.mergePolicy = NSOverwriteMergePolicy
    
    NotificationCenter.default.addObserver(self, selector: #selector(processUpdate(notification:)), name: .NSPersistentStoreRemoteChange, object: nil)
  }
  
  @objc func processUpdate(notification: NSNotification) {
    operationQueue.addOperation { [weak self] in
      let context = self?.container.newBackgroundContext()
      context?.performAndWait {
        let steps:[Steps]
        do {
          let fetch = NSFetchRequest<Steps>(entityName: "Steps")
          try steps = (context?.fetch(fetch))!
        } catch {
          let nserror = error as NSError
          assert(true, error.localizedDescription)
        }
        
        // save if we need to save
        if ((context?.hasChanges) != nil) {
          do {
            try context?.save()
          } catch {
            let nserror = error as NSError
            assert(true, error.localizedDescription)
          }
        }
      }
    }
  }
  
  // =================================================================================
  //                                 MARK: - Fetch
  // =================================================================================

  func fetchSteps(completion: @escaping (Result<[Steps], Error>) -> Void) {
    let fetchRequest = NSFetchRequest<Steps>(entityName: "Steps")
    
    do {
      let steps = try container.viewContext.fetch(fetchRequest)
      if steps.count == 0 {
        completion(.failure(NSError()))
      }
      let sortedSteps = steps.sorted { (s1, s2) in
        s1.date! < s2.date!
      }
      completion(.success(sortedSteps))
    } catch let error as NSError {
      print("CoreData: could not fetch steps - \(error) \(error.userInfo)")
      completion(.failure(error))
    }
  }
  
  func insertSteps(statistics:HKStatistics) {
    guard let newStepEntity = NSEntityDescription.insertNewObject(forEntityName: "Steps", into: container.viewContext) as? Steps else { return }
    let count = statistics.sumQuantity()?.doubleValue(for: .count())
    newStepEntity.count = Int64(count ?? 0)
    newStepEntity.date = statistics.startDate
    saveContext()
  }
  
  func saveContext() {
    if container.viewContext.hasChanges {
      do {
        try container.viewContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
  }
}
