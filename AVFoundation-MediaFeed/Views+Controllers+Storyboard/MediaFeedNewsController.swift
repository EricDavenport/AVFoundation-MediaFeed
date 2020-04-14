//
//  ViewController.swift
//  AVFoundation-MediaFeed
//
//  Created by Eric Davenport on 4/13/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit
import AVFoundation   // video playback is done on a CALayer - all views are back by a CALayer e.g if we make a view rounded we can only do this using the CALayer of that view e.g someView.layer.cornerRadius = 10
import AVKit  // video playback is done using the AVPlayerViewController

class MediaFeedNewsController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var videoButton: UIBarButtonItem!
  @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
  
  private lazy var imagePickerController: UIImagePickerController = {
    let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
    let pickerController = UIImagePickerController()
    
    pickerController.mediaTypes = mediaTypes ?? ["kUTTypeImage"]
    pickerController.delegate = self
    return pickerController
  }()
  
  private var mediaObjects = [MediaObject]() {
    didSet {   // property observer
      collectionView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureCollectionView()
    
    if !UIImagePickerController.isSourceTypeAvailable(.camera) {
      self.videoButton.isEnabled = false
    }
  }
  
  private func configureCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
  }
  
  @IBAction func VideoButtonPressed(_ sender: UIBarButtonItem) {
    imagePickerController.sourceType = .camera
    present(imagePickerController, animated: true)
  }
  
  @IBAction func photoLibraryButtonPressed(_ sender: UIBarButtonItem) {
    imagePickerController.sourceType = .photoLibrary
    present(imagePickerController, animated: true)
  }
  
  private func playRandomVideo(in view: UIView) {
    // we want all non nil media objects from the mediaObjects array
    // compactMap - beacuse it returns all non-nil values
    let videoURLs = mediaObjects.compactMap { $0.videoURL }   // array of all mediaObjects with a videoURL value
    
    // gets random URL
    if let videoURL = videoURLs.randomElement() {
      let player = AVPlayer(url: videoURL)
      
      // create a sublayer
      let playerLayer = AVPlayerLayer(player: player)
      
      // set its frame  -   view = view being passed into function
      playerLayer.frame = view.bounds   // take up entire headerView
      
      // set video aspect ratio
      playerLayer.videoGravity = .resizeAspect
      
      // remove all sublayers from the headerView
      view.layer.sublayers?.removeAll()
      
      // add the playerLayer to the headerViews's layer
      view.layer.addSublayer(playerLayer)
      
      // play vieo
      player.play()
    }
  }
  
  
}

// MARK: UICollection View Datasource methods
extension MediaFeedNewsController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return mediaObjects.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath) as? MediaCell else {
      fatalError("could not dequeue a MediaCell")
    }
    let mediaObject = mediaObjects[indexPath.row]
    cell.configureCell(for: mediaObject)
    return cell
  }
  
// MARK: Header view seretup
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
    guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath) as? HeaderView else {
      fatalError("could not deque a HeaderView")
    }
    playRandomVideo(in: headerView)
    return headerView  // is of the UIReusableView
  }
}

// MARK: UICollectionView Delegate Methods
extension MediaFeedNewsController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let mediaObject = mediaObjects[indexPath.row]
    guard let videoURL = mediaObject.videoURL else {
      return
    }
    let playerViewController = AVPlayerViewController()
    let player = AVPlayer(url: videoURL)
    playerViewController.player = player
    present(playerViewController, animated: true) {
      // plays video automatically
      player.play()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let maxSize: CGSize = UIScreen.main.bounds .size  // max width and height of the current device
    let itemWidth: CGFloat = maxSize.width
    let itemHeight: CGFloat = maxSize.height * 0.40  // 40% of height of device
    return CGSize(width: itemWidth, height: itemHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10 )
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height * 0.40)
  }
  
}

// MARK: UIIMapgePickerController
extension MediaFeedNewsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    // info dictionary keys
    // InfoKey.originalImage - UIImage
    // InfoKey.mediaType - String
    // infoKey.mediaURL - URL
    guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else {
      return
    }
    
    switch mediaType {
    case "public.image":
      if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
        let imageData = originalImage.jpegData(compressionQuality: 1.0) {  // 1.0 = 100% compression
        let mediaObject = MediaObject(imageData: imageData, videoURL: nil, caption: nil)
        mediaObjects.append(mediaObject)  // 0 => 1
        
      }
    case "public.movie":
      if let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
        let mediaObject = MediaObject(imageData: nil, videoURL: mediaURL, caption: nil)
        mediaObjects.append(mediaObject)
        print("mediaURL: \(mediaURL)")
      }
      
    default:
      print("unsupoorted media type")
    }
    
    print("mediaType: \(mediaType)")   // "public.movie" , "public.image"
    imagePickerController.dismiss(animated: true)
  }
}
