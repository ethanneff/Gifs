//
//  Gifs.swift
//  GifsVideosScroll
//
//  Created by Ethan Neff on 8/5/16.
//  Copyright © 2016 Ethan Neff. All rights reserved.
//

import UIKit
import FLAnimatedImage

class Gif {
  var indexPath: IndexPath
  var state: State
  
  var urlGifLarge: URL?
  var urlGifSmall: URL?
  var urlImgSmall: URL?
  var urlImgLarge: URL?
  
  var gifSmall: FLAnimatedImage?
  var gifLarge: FLAnimatedImage?
  
  var imgSmall: UIImage?
  var imgLarge: UIImage?
  
  var imgSmallWidth: CGFloat?
  var imgSmallHeight: CGFloat?
  
  var imgLargeWidth: CGFloat?
  var imgLargeHeight: CGFloat?
  
  typealias completion = () -> ()
  
  enum State: Int {
    case none
    case error
    case size
    case smallImage
    case smallGif
    case largeImage
    case largeGif
  }
  
  enum Failure: Error {
    case noData
    case noLargeGifData
    case noLargeGifDownload
    case noLargeGifConvert
    case noLargeGifWidth
    case noLargeGifHeight
    case noLargeImgData
    case noLargeImgDownload
    case noLargeImgConvert
    case noSmallGifData
    case noSmallGifDownload
    case noSmallGifConvert
    case noSmallGifWidth
    case noSmallGifHeight
    case noSmallImgData
    case noSmallImgDownload
    case noSmallImgConvert
  }
  
  init(indexPath: IndexPath) {
    self.indexPath = indexPath
    self.state = .none
  }
  
  func getSmall(sizeComplete: @escaping completion, imageComplete: @escaping completion, gifComplete: @escaping completion) {
    func errorComplete(error: Failure) {
      // TODO: handle errors
      print(error)
      self.state = .error
      sizeComplete()
      imageComplete()
      gifComplete()
    }
    
    self.state = .none
    Remote.sharedInstance.getRandomGif { json in
      guard let json = json else {
        return errorComplete(error: .noData)
      }
      guard let urlGifLarge = json["data"]["image_url"].string else {
        return errorComplete(error: .noLargeGifData)
      }
      guard let urlGifSmall = json["data"]["fixed_width_small_url"].string else {
        return errorComplete(error: .noSmallGifData)
      }
      guard let urlImgSmall = json["data"]["fixed_width_small_still_url"].string else {
        return errorComplete(error: .noSmallImgData)
      }
      guard let urlImgLarge = json["data"]["fixed_width_small_still_url"].string else {
        return errorComplete(error: .noLargeImgData)
      }
      guard let smallWidth = json["data"]["fixed_width_small_width"].string else {
        return errorComplete(error: .noSmallGifWidth)
      }
      guard let smallHeight = json["data"]["fixed_width_small_height"].string else {
        return errorComplete(error: .noSmallGifHeight)
      }
      guard let largeWidth = json["data"]["fixed_width_small_width"].string else {
        return errorComplete(error: .noLargeGifWidth)
      }
      guard let largeHeight = json["data"]["fixed_width_small_height"].string else {
        return errorComplete(error: .noLargeGifHeight)
      }
      
      // size
      self.urlGifSmall = URL(string: urlGifSmall)
      self.urlGifLarge = URL(string: urlGifLarge)
      self.urlImgSmall = URL(string: urlImgSmall)
      self.urlImgLarge = URL(string: urlImgLarge)
      
      self.imgSmallWidth = CGFloat(Double(smallWidth) ?? 0)
      self.imgSmallHeight = CGFloat(Double(smallHeight) ?? 0)
      self.imgLargeWidth = CGFloat(Double(largeWidth) ?? 0)
      self.imgLargeHeight = CGFloat(Double(largeHeight) ?? 0)
      
      self.state = .size
      sizeComplete()
      
      // small img
      Remote.sharedInstance.getData(url: self.urlImgSmall!, completion: { data in
        guard let data = data else {
          return errorComplete(error: .noSmallImgDownload)
        }
        guard let small = UIImage(data: data as Data) else {
          return errorComplete(error: .noSmallImgConvert)
        }
        
        self.imgSmall = small
        if self.state.rawValue <= State.smallImage.rawValue {
          self.state = .smallImage
        }
        imageComplete()
      })
      
      // small gif
      Remote.sharedInstance.getData(url: self.urlGifSmall!, completion: { data in
        guard let data = data else {
          return errorComplete(error: .noSmallGifDownload)
        }
        guard let small = FLAnimatedImage(animatedGIFData: data as Data!) else {
          return errorComplete(error: .noSmallGifConvert)
        }
        
        self.gifSmall = small
        if self.state.rawValue <= State.smallGif.rawValue {
          self.state = .smallGif
        }
        gifComplete()
      })
    }
  }
  
  func getLarge(imageCompete imageComplete: @escaping completion, gifComplete: @escaping completion) {
    func errorComplete(error: Failure) {
      // TODO: handle errors
      print(error)
      self.state = .error
      imageComplete()
      gifComplete()
    }
    
    // large img
    Remote.sharedInstance.getData(url: self.urlImgLarge!, completion: { data in
      guard let data = data else {
        return errorComplete(error: .noLargeImgDownload)
      }
      guard let large = UIImage(data: data as Data) else {
        return errorComplete(error: .noSmallImgConvert)
      }
      
      self.imgLarge = large
      if self.state != .largeGif {
        self.state = .largeImage
      }
      imageComplete()
    })
    
    // large gif
    Remote.sharedInstance.getData(url: self.urlGifSmall!, completion: { data in
      guard let data = data else {
        return errorComplete(error: .noSmallGifDownload)
      }
      guard let large = FLAnimatedImage(animatedGIFData: data as Data) else {
        return errorComplete(error: .noSmallGifConvert)
      }
      
      self.gifLarge = large
      self.state = .largeImage
      gifComplete()
    })
  }
}
