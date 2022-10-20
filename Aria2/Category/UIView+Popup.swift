//
//  UIView+Popup.swift
//  my_iPad
//
//  Created by my on 2022/1/25.
//

import Foundation
import UIKit

extension UIView {
    
    /// 从右边滑出展示
    func showFromRight() {
        let window = UIApplication.shared.keyWindow
        let alphaView = UIView(frame: window!.bounds)
        alphaView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        alphaView.tag = 123456789
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        alphaView.addGestureRecognizer(tapGesture)
        window?.addSubview(alphaView)
        
        self.frame = CGRect(x: ScreenWidth, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        window?.addSubview(self)
        UIView.animate(withDuration: 0.25, delay: 0) {
            self.frame = CGRect(x: ScreenWidth-self.bounds.size.width, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        } completion: { result in
            
        }
    }
    
    @objc func tapAction() {
        let window = UIApplication.shared.keyWindow
        for v in window!.subviews {
            if v.tag == 123456789 {
                UIView.animate(withDuration: 0.25, delay: 0) {
                    self.frame = CGRect(x: ScreenWidth, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
                } completion: { result in
                    v.removeFromSuperview()
                    self.removeFromSuperview()
                }
                break
            }
        }
    }
    
}
