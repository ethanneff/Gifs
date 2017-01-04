//
//  Remote.swift
//  GifsVideosScroll
//
//  Created by Ethan Neff on 8/5/16.
//  Copyright © 2016 Ethan Neff. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Remote {
  static let sharedInstance = Remote()
  fileprivate init() {}
  
  var gifApi = "http://api.giphy.com/v1/gifs/"
  let gifKey = "dc6zaTOxFJmzC"
  var trendingGif = "http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC"
  var searchGif = "http://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC"
  let randomVid = "http://ytroulette.com/"
  
  func getRandomGif(_ completion: @escaping (_ json: JSON?) -> ()) {
    let url = "\(gifApi)random?api_key=\(gifKey)&tag=cat"
    getJSON(url: url, completion: completion)
  }
  
  func getTrending(_ limit: Int, offset: Int, completion: @escaping (_ json: JSON?) -> ()) {
    let url = "\(gifApi)trending?api_key=\(gifKey)&limit =\(limit)&offset=\(offset)"
    getJSON(url: url, completion: completion)
  }
  
  func getSearch(_ limit: Int, offset: Int, query: String, completion: @escaping (_ json: JSON?) -> ()) {
    let url = "\(gifApi)search?api_key=\(gifKey)&limit =\(limit)&offset=\(offset)&q=\(query)"
    getJSON(url: url, completion: completion)
  }
  
  fileprivate func getJSON(url: String, completion: @escaping (_ json: JSON?) -> ()) {
    Alamofire.request(url, method: .get)
      .validate()
      .responseJSON { response in
        switch response.result {
        case .success:
          if let value = response.result.value {
            let json = JSON(value)
            completion(json)
          }
        case .failure(let error):
          print(error)
          completion(nil)
        }
    }
  }
  
  func getData(url: URL, completion: @escaping (_ data: NSData?) -> ()) {
    Alamofire.request(url, method: .get)
      .validate()
      .responseData { response in
        switch response.result {
        case .success:
          if let value = response.result.value {
            completion(value as NSData?)
          }
        case .failure(let error):
          print(error)
          completion(nil)
        }
    }
  }
}
