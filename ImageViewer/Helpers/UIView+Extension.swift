//
//  UIView+Extension.swift
//  ImageViewer
//
//  Created by Alexander Konovalov on 07.10.2021.
//

import UIKit

extension UIView {
    public func startActivity(_ style: UIActivityIndicatorView.Style,
                              tag: Int = 1234122,
                              alpha: CGFloat = 0.5) {

        guard viewWithTag(tag) == nil else { return }
        
        let back = UIView(frame: self.frame)
        self.addSubview(back)
        back.backgroundColor = UIColor.white.withAlphaComponent(alpha)
        back.tag = tag
        
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: self.topAnchor),
            back.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            back.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            back.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        let activity = UIActivityIndicatorView(style: style)
        back.addSubview(activity)
        activity.hidesWhenStopped = true
        activity.center = self.center
        activity.color = .blue
        
        activity.startAnimating()
    }
    
    public func stopActivity(tag: Int = 1234122) {
        if let back = viewWithTag(tag) {
            back.removeFromSuperview()
        }
    }
}
