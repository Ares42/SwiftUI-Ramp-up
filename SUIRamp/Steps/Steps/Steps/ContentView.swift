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
  @State private var steps = [Step]()
  
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
          Text("\(step.date, formatter: Self.dateFormatter):")
            .fontWeight(.bold)
          Text("\(step.step)")
            .font(.caption)
        }
        .padding()
      }
    }
    .onAppear {
      if let healthDataManager = healthDataManager {
        healthDataManager.requestAuthorization { success in
          if success {
            healthDataManager.fetchStepArray { response in
              if case .success(let stepsResonse) = response {
                steps = stepsResonse
              } else if case .failure(_) = response {
                print("failure fetching steps")
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

}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
