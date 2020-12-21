//
//  SUIRampApp.swift
//  SUIRamp
//
//  Created by Luke Solomon on 12/17/20.
//

import SwiftUI

@main
struct SUIRampApp: App {
  let persistenceController = PersistenceController.shared
//  @StateObject private var modelData = ModelData()

  var body: some Scene {
    WindowGroup {
//      MainView()
//        .environmentObject(ModelData())
      ContentView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}

