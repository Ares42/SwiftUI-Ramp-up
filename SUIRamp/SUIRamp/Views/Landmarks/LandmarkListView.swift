//
//  LandmarkListView.swift
//  SUIRamp
//
//  Created by Luke Solomon on 12/17/20.
//

import SwiftUI

struct LandmarkListView: View {
  @EnvironmentObject var modelData: ModelData
  @State private var showFavoritesOnly = false
  
  var filteredLandmarks: [Landmark] {
    modelData.landmarks.filter { landmark in
      (!showFavoritesOnly || landmark.isFavorite)
    }
  }
  
  var body: some View {
    NavigationView {
      List {
        Toggle(isOn: $showFavoritesOnly) {
          Text("Favorites only")
        }
        ForEach(filteredLandmarks) { landmark in
          NavigationLink(destination: LandmarkDetail(landmark: landmark)) {
            LandmarkRow(landmark: landmark)
          }
        }
      }
      .navigationTitle("Landmarks")
    }
  }
}

struct LandmarkListView_Previews: PreviewProvider {
  static var previews: some View {
    LandmarkListView()
      .environmentObject(ModelData())
  }
}
