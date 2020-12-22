//
//  ManagedLandmark.swift
//  SUIRamp
//
//  Created by Luke Solomon on 12/21/20.
//

import CoreData
import SwiftUI
import CoreLocation

class ManagedLandmark: NSManagedObject {
  @NSManaged var id:Int
  @NSManaged var name:String
  @NSManaged var park:String
  @NSManaged var state:String
  @NSManaged override var description:String
  @NSManaged var isFavorite:Bool
  
  @NSManaged private var imageName:String
  
  var image:Image {
    Image(imageName)
  }
}

extension ManagedLandmark {
  static func getManagedLandmarkFetchRequest() -> NSFetchRequest<ManagedLandmark>{
    let request = ManagedLandmark.fetchRequest() as! NSFetchRequest<ManagedLandmark>
    request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
    return request
  }
}
