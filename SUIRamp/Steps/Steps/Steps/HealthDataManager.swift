//
//  HealthDataManager.swift
//  Steps
//
//  Created by Luke Solomon on 12/23/20.
//

import Foundation
import HealthKit
import CoreData

struct Step: Identifiable {
  var id:Int
  var step:Int
  var date:Date
}

enum HealthError:Error {
  case noHealthDataAvailable
  case fetchFailed
}

class HealthDataManager {
  var healthStore: HKHealthStore?
  var query: HKStatisticsCollectionQuery?
  
  init() {
    if HKHealthStore.isHealthDataAvailable() {
      healthStore = HKHealthStore()
    }
  }
  
  func requestAuthorization(completion: @escaping (Bool) -> ()) {
    guard HKHealthStore.isHealthDataAvailable() else {
      completion(false)
      return
    }
    
    let healthKitTypesToRead: Set<HKObjectType> = [HKObjectType.quantityType(forIdentifier: .stepCount)!]
    
    HKHealthStore().requestAuthorization(toShare: [], read: healthKitTypesToRead) { (success, error) in
      completion(success)
      return
    }
  }
  
  func calculateSteps(completion: @escaping (Result<HKStatisticsCollection?, HealthError>) -> Void) {
    let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
    let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
    let anchorDate = Date()
    let daily = DateComponents(day: 1)
    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
    
    query = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
    query!.initialResultsHandler = { query, statisticsCollection, error in
      completion(.success(statisticsCollection))
    }
    
    if let healthStore = healthStore, let query = self.query {
      healthStore.execute(query)
    }
  }
  
  func fetchStepArray(completion: @escaping(Result<[Step], HealthError>)->()) {
    var result = [Step]()
    
    PersistenceController.shared.fetchSteps { [weak self] (response) in
      if case .success(let steps) = response {
        for (i, step) in steps.enumerated() {
          let newStep = Step(id: i, step: Int(step.count), date: step.date!)
          result.append(newStep)
        }
        completion(.success(result))
      } else if case .failure(_) = response {
        self?.calculateSteps { (response) in
          if case .success(let statisticsCollection) = response {
            
            let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
            let endDate = Date()
            
            var i = 0
            statisticsCollection?.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
              PersistenceController.shared.insertSteps(statistics: statistics)
              let count = Int(statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0)
              let newStep = Step(id: i, step: count, date: statistics.startDate)
              i += 1
              result.append(newStep)
            }
            completion(.success(result))
            
          } else if case .failure(let error) = response {
            print(error)
            completion(.failure(.fetchFailed))
          }
        }
        completion(.failure(.fetchFailed))
      }
    }
  }
  
}
