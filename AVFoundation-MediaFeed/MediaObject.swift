//
//  MediaObject.swift
//  AVFoundation-MediaFeed
//
//  Created by Eric Davenport on 4/13/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import Foundation

// mediaObject instance can either be a video or an image content
struct MediaObject {
  let imageData: Data?
  let videoURL: URL?
  let caption: String?  // UI so user can enter text
  
  // whenever creating a custom object have an id and date
  let id = UUID().uuidString
  let date = Date()
}
