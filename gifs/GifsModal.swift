//
//  GifsViewControllerModalz.swift
//  gifs
//
//  Created by Ethan Neff on 8/9/16.
//  Copyright © 2016 Ethan Neff. All rights reserved.
//

import UIKit

class GifsModal: UIViewController {
  // MARK: - properties
  var modalz: UIView!

  var completion: completionBlock
  var tapToClose: UITapGestureRecognizer = UITapGestureRecognizer()
  let animationDuration: TimeInterval = 0.25
  let radius: CGFloat = 15
  let separatorHeight: CGFloat = 0.5
  let buttonConfirmTitle: String = "Okay"
  let buttonCancelTitle: String = "Cancel"

  typealias completionBlock = ((_ output: [String: AnyObject]) -> ())?

  // MARK: - init
  init() {
    super.init(nibName: nil, bundle: nil)
    modalz = createModal()
    setupModal()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init coder not implemented")
  }

  deinit {

  }

}
extension GifsModal {
  // MARK: - public
  func show(controller: UIViewController, dismissible: Bool = false, completion: completionBlock = nil) {
    self.modalPresentationStyle = .overCurrentContext
    controller.present(self, animated: false) {
      self.animateIn() {
        if dismissible {
          self.tapToClose.addTarget(self, action: #selector(self.tapToClosePressed(_:)))
          self.view.addGestureRecognizer(self.tapToClose)
        }
        self.completion = completion
      }
    }
  }

  func hide(_ completion: (() -> ())? = nil) {
    self.animateOut() {
      self.dismiss(animated: false, completion: {
        if let completion = completion {
          completion()
        }
        self.completion = nil
      })
    }

  }

  // MARK: - gestures
  internal func tapToClosePressed(_ gesture: UITapGestureRecognizer) {
    // click backdrop
    if !modalz.frame.contains(gesture.location(in: view)) {
      hide()
    }
  }
}

extension GifsModal {
  // MARK: - animation
  fileprivate func animateOut(_ completion: @escaping () -> ()) {
    modalz.transform = CGAffineTransform.identity
    modalz.alpha = 1
    view.alpha = 1
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseOut, animations: {
      self.modalz.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
      self.modalz.alpha = 0
      self.view.alpha = 0
    }) { finished in
      completion()
    }
  }

  fileprivate func animateIn(_ completion: (() -> ())? = nil) {
    modalz.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    modalz.alpha = 0
    view.alpha = 0
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseOut, animations: {
      self.modalz.transform = CGAffineTransform.identity
      self.modalz.alpha = 1
      self.view.alpha = 1
    }) { finished in
      if let completion = completion {
        completion()
      }
    }
  }
}


extension GifsModal {
  func createModal() -> UIView {
    let modalz: UIView = UIView()
    modalz.backgroundColor = .white
    modalz.layer.cornerRadius = radius
    modalz.layer.masksToBounds = true
    modalz.translatesAutoresizingMaskIntoConstraints = false
    modalz.alpha = 0
    view.alpha = 0
    view.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.2)
    view.addSubview(modalz)

    return modalz
  }

  fileprivate func setupModal() {
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: modalz, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: modalz, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: modalz, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.7, constant: 0),
      NSLayoutConstraint(item: modalz, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.7, constant: 0),
      ])

  }
}
