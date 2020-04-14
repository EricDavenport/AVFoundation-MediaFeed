//
//  CoreDataManager.swift
//  AVFoundation-MediaFeed
//
//  Created by Eric Davenport on 4/14/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
  
  // creating a singleton for CoreDataManager
  private init() { }
  static let shared = CoreDataManager()
  
  private var mediaObjects = [CDMediaObject]()
  
  // get instance of NSManagedObjectContext from the AppDelegate
  private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  // NSManagedObjectContext does saving, fetching, on NSManagedObjects...
  
  // CRUD - create
  // converting UIImage to Data
  func createMediaObject(_ imageData: Data, videoURL: URL?) -> CDMediaObject {
    let mediaObject = CDMediaObject(entity: CDMediaObject.entity(), insertInto: context)
    mediaObject.createDate = Date()  // current date
    mediaObject.id = UUID().uuidString  // unique string
    mediaObject.imageData = imageData   // both video and image objects has an image - video's extension
    if let videoURL = videoURL {  // if exist, this means it's a video object
      // convert a URL to Data
      do {
        mediaObject.videoData = try Data(contentsOf: videoURL)
      } catch {
        print("Failed to convert URL to Data with eror: \(error)")
      }
    }
    
    // save the newlt created mediaObject entity instance to the NSManagedObjectContext
    do {
      try context.save()
    } catch {
      print("Failed to save newly created media object with error: \(error)")
    }
    
    return mediaObject
  }
  
  // read
  func fetchMediaObjects() -> [CDMediaObject] {
    do {
      mediaObjects = try context.fetch(CDMediaObject.fetchRequest())   // fetch all of the created objects from the CDMediaObject entity
    } catch {
      print("Failed to fetch media objects with error: \(error)")
    }
    return mediaObjects
    
  }
  
  // update
  
  // delete

  
}
