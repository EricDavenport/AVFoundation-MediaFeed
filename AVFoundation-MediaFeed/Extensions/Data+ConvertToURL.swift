//
//  Data+ConvertToURL.swift
//  AVFoundation-MediaFeed
//
//  Created by Eric Davenport on 4/15/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import Foundation

extension Data {
  
  // use example:
  // let url = mediaObject.videoData.convertToURL()
  //
  public func convertToURL() -> URL? {
    // create a temporary URL
    // NSTemporaryDirectory() - stores temporary files, those files get deleted
    // documents directory is for permanent storage
    // caches directory is temporary storage
    
    // in Core Data the video is saved as Data
    // when playing back the video we need to have a URL pointing to the video location on disk
    // AVPlayer needs a URL pointing to a location disk
    let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("video").appendingPathExtension("mp4")
    
    do {
      // abilitiy to say self - self refers to video data
      try self.write(to: tempURL, options: [.atomic])   // write everything at once
      return tempURL
    } catch {
      print("failed to write video data to temporary file with error: \(error)")
    }
    return nil
  }
}
