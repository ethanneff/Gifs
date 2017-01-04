//
//  VideosViewControllerCell.swift
//  GifsVideosScroll
//
//  Created by Ethan Neff on 8/5/16.
//  Copyright © 2016 Ethan Neff. All rights reserved.
//

import UIKit
import FLAnimatedImage

class GifsViewControllerCell: UICollectionViewCell {
  // MARK: - properties
  static let identifier: String = "cell"
  
  let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
  let imageView: UIImageView = UIImageView()
  let gifView: FLAnimatedImageView = FLAnimatedImageView()
  let errorLabel: UILabel = UILabel()
  
  // MARK: - init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupGifView()
    setupImageView()
    setupErrorLabel()
    setupActivityIndicator()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - data
extension GifsViewControllerCell {
  func loadData(data: Gif) {
    resetView()
    switch data.state {
    case .error:
      errorLabel.isHidden = false
      errorLabel.text = "try again"
      break
    case .smallImage:
      imageView.isHidden = false
      imageView.image = data.imgSmall
      activityIndicator.isHidden = false
      activityIndicator.startAnimating()
      break
    case .smallGif:
      gifView.isHidden = false
      gifView.animatedImage = data.gifSmall
      break
    case .none, .size:
      activityIndicator.isHidden = false
      activityIndicator.startAnimating()
      break
    default: break
    }
  }
  
  fileprivate func resetView() {
    errorLabel.isHidden = true
    gifView.isHidden = true
    imageView.isHidden = true
    activityIndicator.isHidden = true
    activityIndicator.stopAnimating()
  }
}

// MARK: - setup
extension GifsViewControllerCell {
  func setupView() {
    backgroundColor = .white
    layer.masksToBounds = true
    layer.cornerRadius = 10
  }
  
  func setupActivityIndicator() {
    addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: activityIndicator, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: activityIndicator, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: activityIndicator, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: activityIndicator, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
      ])
  }
  
  func setupGifView() {
    gifView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(gifView)
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: gifView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: gifView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: gifView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: gifView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
      ])
  }
  
  func setupImageView() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(imageView)
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
      ])
  }
  
  func setupErrorLabel() {
    errorLabel.translatesAutoresizingMaskIntoConstraints = false
    errorLabel.textAlignment = .center
    errorLabel.textColor = .white
    errorLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    addSubview(errorLabel)
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: errorLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: errorLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: errorLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: errorLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
      ])
  }
}
