//
//  StepsApp.swift
//  Steps
//
//  Created by Luke Solomon on 12/23/20.
//

import SwiftUI

@main
struct StepsApp: App {
  let persistenceController = PersistenceController.shared
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}
