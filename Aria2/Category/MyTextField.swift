//
//  MyTextField.swift
//  my_iPad
//
//  Created by my on 2022/1/19.
//

import Foundation
import UIKit

class MyTextField: UITextField {
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect = CGRect(x: rect.origin.x-10, y: rect.origin.y, width: 30, height: 30)
        return rect
    }
    
}

class MySearchTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return CGRect(x: 10, y: rect.origin.y, width: rect.width, height: rect.height)
    }
    
}
