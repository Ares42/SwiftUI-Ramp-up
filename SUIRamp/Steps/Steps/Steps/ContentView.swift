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


/*
1 Animar, Soul of Elements
1 Arcane Signet
1 Auspicious Starrix
1 Beast Within
1 Birds of Paradise
1 Blasphemous Act
1 Blighted Woodland
1 Bonders' Enclave
1 Brainstorm
1 Breeding Pool
1 Castle Embereth
1 Collective Voyage
1 Colossification
1 Command Tower
1 Commander's Sphere
1 Counterspell
1 Cragcrown Pathway
1 Cyclonic Rift
1 Darksteel Myr
1 Darksteel Plate
1 Dictate of Kruphix
1 Dreamtail Heron
1 Elder Gargaroth
1 Embercleave
1 Essence Symbiote
1 Evacuation
1 Everquill Phoenix
1 Flitterstep Eidolon
1 Flooded Grove
1 Frontier Bivouac
1 Gemrazer
1 Genesis Ultimatum
1 Gladecover Scout
1 Glowstone Recluse
1 Gruul Turf
1 Hammer of Nazahn
1 Harrow
1 Heartbeat of Spring
1 Heroic Intervention
1 Hinterland Harbor
1 Hydra's Growth
1 Invisible Stalker
1 Jace Beleren
1 Ketria Crystal
1 Ketria Triome
1 Lightning Greaves
1 Mountain
1 Myriad Landscape
1 Mysterious Egg
1 New Frontiers
1 Ponder
1 Primal Empathy
1 Quartzwood Crasher
1 Questing Beast
1 Radha, Heart of Keld
1 Ram Through
1 Rapid Hybridization
1 Rhystic Study
1 Riverglide Pathway
1 Rogue's Passage
1 Runes of the Deus
1 Sea-Dasher Octopus
1 Seedborn Muse
1 Shadowspear
1 Silent Arbiter
1 Silhana Ledgewalker
1 Slippery Bogle
1 Sol Ring
1 Song of Creation
1 Spearpoint Oread
1 Sublime Epiphany
1 Sulfur Falls
1 Swiftfoot Boots
1 Sword of Vengeance
1 Tempt with Discovery
1 Temur Charm
1 Thwart the Enemy
1 Training Center
1 Trumpeting Gnarr
1 Vivien, Champion of the Wilds
1 Witchstalker
 */
