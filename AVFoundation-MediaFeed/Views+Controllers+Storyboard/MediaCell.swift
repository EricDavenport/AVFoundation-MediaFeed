//
//  MediaCell.swift
//  AVFoundation-MediaFeed
//
//  Created by Eric Davenport on 4/13/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit

class MediaCell: UICollectionViewCell {
    
  @IBOutlet weak var mediaImageView: UIImageView!
  
  public func configureCell(for mediaObject: MediaObject) {
    if let imageData = mediaObject.imageData {
      // converts a Data object to a UIImage
      mediaImageView.image = UIImage(data: imageData)
    }
    
    // TODO: Create media imageView thumbnail
    if let videoURL = mediaObject.videoURL {
      let image = videoURL.videoPreviewThumbnail() ?? UIImage(systemName: "xmark.octagon.fill")
      mediaImageView.image = image
    }
  }
}
