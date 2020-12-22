//
//  FavoriteView.swift
//  SUIRamp
//
//  Created by Luke Solomon on 12/18/20.
//

import SwiftUI

struct FavoriteButton: View {
  @Binding var isSet: Bool
  
  var body: some View {
    Button(action: {
      isSet.toggle()
    }) {
      Image(systemName: isSet ? "star.fill" : "star")
        .foregroundColor(isSet ? Color.yellow : Color.gray)
    }
  }
}

struct FavoriteView_Previews: PreviewProvider {
  static var previews: some View {
    FavoriteButton(isSet: .constant(true))
  }
}
