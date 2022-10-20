

import Foundation
import UIKit

extension UIView {
    func setborder(withColor color:UIColor, withWidth width:CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func setCornerRadius(radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func goodCornerRadius(radius:CGFloat) {
        if #available(iOS 11.0, *) {
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            let path:UIBezierPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    //设置阴影
    func setShadow(color: UIColor, offset: CGSize, opacity: Float, radius: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset//偏移量
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius//扩散半径
    }
    
    
    func removeTextLayer(water:String)  {
        let layers = self.layer.sublayers
        var sublayers = [CALayer]()
        
        for (idx,layer) in (layers?.enumerated())! {
            
            if layer .isKind(of: CATextLayer.self) {
                let textLayer = layer as!CATextLayer
                
                let waterText:String = textLayer.string as! String
                
                guard water == waterText else {
                    return
                }
                
            }else{
                sublayers.append(layer)
            }
            print(layer.frame,idx)
        }
        self.layer.sublayers = sublayers
        
    }
}

extension UIButton {
    //title的位置
    enum Position: Int {
        case top, bottom, left, right
    }
    
    func set(image: UIImage?, title: String, titlePosition: Position, additionalSpacing: CGFloat, state: UIControl.State){
        imageView?.contentMode = .center
        setImage(image, for: state)
        setTitle(title, for: state)
        titleLabel?.contentMode = .center

        adjust(title: title as NSString, at: titlePosition, with: additionalSpacing)
        
    }
    
    func set(image: UIImage?, attributedTitle title: NSAttributedString, at position: Position, width spacing: CGFloat, state: UIControl.State){
        imageView?.contentMode = .center
        setImage(image, for: state)
        
        adjust(attributedTitle: title, at: position, with: spacing)
        
        titleLabel?.contentMode = .center
        setAttributedTitle(title, for: state)
    }
    
    private func adjust(title: NSString, at position: Position, with spacing: CGFloat) {
        let imageRect: CGRect = self.imageRect(forContentRect: frame)
        
        // Use predefined font, otherwise use the default
        let titleFont: UIFont = titleLabel?.font ?? UIFont()
        let titleSize: CGSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont])
        
        arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
    }
    
    private func adjust(attributedTitle: NSAttributedString, at position: Position, with spacing: CGFloat) {
        let imageRect: CGRect = self.imageRect(forContentRect: frame)
        let titleSize = attributedTitle.size()
        
        arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
    }
    
    private func arrange(titleSize: CGSize, imageRect:CGRect, atPosition position: Position, withSpacing spacing: CGFloat) {
        switch (position) {
        case .top:
            titleEdgeInsets = UIEdgeInsets(top: -(imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
            contentEdgeInsets = UIEdgeInsets(top: spacing / 2 + titleSize.height, left: -imageRect.width/2, bottom: 0, right: -imageRect.width/2)
        case .bottom:
            titleEdgeInsets = UIEdgeInsets(top: (imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: -imageRect.width/2, bottom: spacing / 2 + titleSize.height, right: -imageRect.width/2)
        case .left:
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageRect.width * 2), bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing / 2)
        case .right:
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing / 2)
        }
    }
    
    //
    enum ImagePosition: NSInteger{
        case left = 0
        case right = 1
        case top = 2
        case bottom = 3
    }
    ///务必设置了图片才调用此方法
        func setImagePosition(position: ImagePosition, spacing: CGFloat) {
            
            self.setTitle(self.currentTitle, for: .normal)
            self.setImage(self.currentImage, for: .normal)
            
            let imageWidth:CGFloat = (self.imageView?.image?.size.width)!
            let imageHeight:CGFloat = (self.imageView?.image?.size.height)!
            
            let titleStr:NSString = (self.titleLabel?.text)! as NSString
            let font:UIFont = self.titleLabel!.font
            let attributes = [NSAttributedString.Key.font:font]
            let option = NSStringDrawingOptions.usesLineFragmentOrigin
            let rect:CGRect = titleStr.boundingRect(with: CGSize(width: LONG_MAX, height: LONG_MAX), options: option, attributes: attributes , context: nil)
            
            let labelWidth:CGFloat = rect.width
            let labelHeight:CGFloat = rect.height
            
            let imageOffsetX:CGFloat = (imageWidth + labelWidth) / 2.0 - imageWidth/2.0
            let imageOffsetY:CGFloat = imageHeight / 2.0 + spacing / 2.0
            let labelOffsetX:CGFloat = (imageWidth + labelWidth / 2.0) - (imageWidth + labelWidth)/2.0
            let labelOffsetY:CGFloat = labelHeight / 2.0 + spacing / 2.0
            
            let tempWidth:CGFloat = max(labelWidth, imageWidth)
            let changedWidth:CGFloat = labelWidth + imageWidth - tempWidth
            let tempHeight:CGFloat = max(labelHeight, imageHeight)
            let changedHeight:CGFloat = labelHeight + imageHeight + spacing - tempHeight
            
            switch position {
            case .left:
                self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing/2.0, bottom: 0, right: spacing/2.0)
                self.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2.0, bottom: 0, right: -spacing/2.0)
                self.contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2.0, bottom: 0, right: spacing/2.0)
                break
            case .right:
                self.imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth + spacing/2.0, bottom: 0, right: -(labelWidth + spacing / 2.0))
                self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageWidth + spacing/2), bottom: 0, right: imageWidth + spacing/2)
                self.contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2.0, bottom: 0, right: spacing/2.0)
                break
            case .top:
                self.imageEdgeInsets = UIEdgeInsets(top: -imageOffsetY, left: imageOffsetX, bottom: imageOffsetY, right: -imageOffsetX)
                self.titleEdgeInsets = UIEdgeInsets(top: labelOffsetY, left: -labelOffsetX, bottom: -labelOffsetY, right: labelOffsetX)
                self.contentEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: -changedWidth/2, bottom: changedHeight-imageOffsetY, right: -changedWidth/2)
                break
            case .bottom:
                self.imageEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: imageOffsetX, bottom: -imageOffsetY, right: -imageOffsetX)
                self.titleEdgeInsets = UIEdgeInsets(top: -labelOffsetY, left: -labelOffsetX, bottom: labelOffsetY, right: labelOffsetX)
                self.contentEdgeInsets = UIEdgeInsets(top: changedHeight-imageOffsetY, left: -changedWidth/2, bottom: imageOffsetY, right: -changedWidth/2)
                break
            }
        }
    
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
