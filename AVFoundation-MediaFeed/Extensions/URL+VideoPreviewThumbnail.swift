//
//  URL+VideoPreviewThumbnail.swift
//  AVFoundation-MediaFeed
//
//  Created by Eric Davenport on 4/13/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import AVFoundation
import UIKit

extension URL {
  
  public func videoPreviewThumbnail() -> UIImage? {
    // create an AVAsset instance
    // let image = mediaObject.videoURL.videoPreviewThumbnail()
    let asset = AVAsset(url: self)  // self is the URL instance
    
    // the AVFoundationGenerator is an AVFoundation class that converts a given media to url to an image
    let assetGenerator = AVAssetImageGenerator(asset: asset)
    
    // we want to maintain the aspect ratio of the video
    assetGenerator.appliesPreferredTrackTransform = true
    
    // create a time stamp of needed location within the video
    // we will use a CMTimeto generate the given timestamp
    // CMTime is a part of Core Media
    let timestamp = CMTime(seconds: 3, preferredTimescale: 60)
    // retrieves the first second of the video
    
    var image: UIImage?
    
    do {
      let cgImage = try assetGenerator.copyCGImage(at: timestamp, actualTime: nil)
      image = UIImage(cgImage: cgImage)
      // lower level API dont know about UIKIt, AVKit
      // change the color of the UIView border
      // e.g someView.layer.borderColor = UIColor.green.cgColor
      
    } catch {
      print("failed to generate image")
    }
    
    return image
  }
  
  
}
