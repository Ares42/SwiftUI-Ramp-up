//
//  ContentView.swift
//  Steps
//
//  Created by Luke Solomon on 12/23/20.
//

import SwiftUI
import CoreData
import HealthKit

struct ContentView: View {
  @Environment(\.managedObjectContext) private var viewContext
  
  @FetchRequest(
    entity: Steps.entity(),
    sortDescriptors: []
  )
  
  var steps: FetchedResults<Steps>
  
  private var healthDataManager:HealthDataManager?
  
  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM dd"
    return formatter
  }()
  
  //MARK: - Body
  var body: some View {
    List {
      ForEach(steps) { step in
        HStack{
          Text("\(step.date!, formatter: Self.dateFormatter):")
            .fontWeight(.bold)
          Text("\(step.count)")
            .font(.caption)
        }
        .padding()
      }
    }
    .onAppear {
      if let healthDataManager = healthDataManager {
        healthDataManager.requestAuthorization { success in
          if success {
            healthDataManager.calculateSteps { statisticsCollection in
              if let statisticsCollection = statisticsCollection {
                // update the UI
                updateUIFromStatistics(statisticsCollection)
              }
            }
          }
        }
      }
    }
    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
  }
  
  //MARK: - Init
  init() {
    healthDataManager = HealthDataManager()
  }
  
  private func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection) {
    let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    let endDate = Date()
    
    statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
      let newStep = Steps(context: viewContext)
      let count = statistics.sumQuantity()?.doubleValue(for: .count())
      newStep.count = Int64(count ?? 0)
      newStep.date = statistics.startDate
    }
    
    saveContext()
  }
  
  func saveContext() {
    if viewContext.hasChanges {
      do {
        try viewContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
