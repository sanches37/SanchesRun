//
//  CustomWindowView.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/03/17.
//

import NMapsMap

class CustomWindowView: NSObject, NMFOverlayImageDataSource {
  let color: UIColor
  
  init(color: UIColor) {
    self.color = color
  }
  
  func view(with overlay: NMFOverlay) -> UIView {
    let label: UIView = {
      let label = UIView()
      let backgroundSize: CGFloat = 13
      label.frame =
      CGRect(x: 0, y: 0, width: backgroundSize, height: backgroundSize)
      label.layer.cornerRadius = backgroundSize / 2
      label.layer.borderWidth = 0.8
      label.layer.borderColor = UIColor.black.cgColor
      label.clipsToBounds = true
      label.backgroundColor = color
      return label
    }()
    return label
  }
}
