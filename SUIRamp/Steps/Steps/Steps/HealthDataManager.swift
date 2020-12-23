//
//  HealthDataManager.swift
//  Steps
//
//  Created by Luke Solomon on 12/23/20.
//

import Foundation
import HealthKit

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
  
  func calculateSteps(completion: @escaping (HKStatisticsCollection?) -> Void) {
    let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
    let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
    let anchorDate = Date()
    let daily = DateComponents(day: 1)
    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
    
    query = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
    query!.initialResultsHandler = { query, statisticsCollection, error in
      completion(statisticsCollection)
    }
    
    if let healthStore = healthStore, let query = self.query {
      healthStore.execute(query)
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
  
}
