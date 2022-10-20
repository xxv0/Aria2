

import UIKit

class UISetupView: NSObject {
    
    /// 初始化UILabel
    ///
    /// - Parameters:
    ///   - superView: superView
    ///   - text: text
    ///   - textColor: textColor
    ///   - fontSize: fontSize
    /// - Returns: UILabel
    static func setupLabel(superView:UIView!, text: String?, textColor:UIColor?, fontSize:Float) -> UILabel {
        let label = UILabel.init()
//        if !text!.isEmpty {
//            label.text = text
//        }
        label.text = text
        if textColor != nil {
            label.textColor = textColor
        }
        if fontSize > 0 {
            label.font = .systemFont(ofSize: CGFloat(fontSize))
        }
        superView.addSubview(label)
        
        return label
    }
    
    
    /// 初始化UIImageView
    ///
    /// - Parameters:
    ///   - superView: superView
    ///   - imageName: imageName
    /// - Returns: UIImageView
    static func setupImageView(superView:UIView, imageName:String) -> UIImageView {
        let imageView = UIImageView.init()
        if !imageName.isEmpty {
            if imageName.count > 0 {
                imageView.image = UIImage(named: imageName)
            }
        }
        superView.addSubview(imageView)

        return imageView
    }
    
    /// 初始化UIButton
    ///
    /// - Parameters:
    ///   - superView: superView
    ///   - image: image
    /// - Returns: UIButton
    static func setupImageButton(superView:UIView, image:UIImage!) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        
        superView.addSubview(button)
        
        return button
    }
    
    /// 初始化UIButton
    ///
    /// - Parameters:
    ///   - superView: superView
    ///   - title: title
    ///   - titleColor: titleColor
    ///   - titleFontSize: titleFontSize
    /// - Returns: UIButton
    static func setupTitleButton(superView:UIView, title:String!, titleColor:UIColor, titleFontSize:Float) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(titleFontSize))
        superView.addSubview(button)
        
        return button
    }
    
    
    /// 初始化 线
    ///
    /// - Parameter superView: superView
    /// - Returns: line
    static func setupLine(superView:UIView) -> UIView {
        let line = UIView.init()
        line.backgroundColor = .systemGray
        superView.addSubview(line)
        
        return line
    }
    
    
    /// 画虚线
    ///
    /// - Parameters:
    ///   - line: line
    ///   - lineLength: lineLength
    ///   - lineSpacing: lineSpacing
    ///   - lineColor: lineColor
    static func drawDashLine(line:UIView, lineLength:Int, lineSpacing:Int, lineColor:UIColor) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = line.bounds
        shapeLayer.position = CGPoint(x: line.frame.width/2, y: line.frame.height)
        shapeLayer.fillColor = lineColor.cgColor
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = line.frame.height
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [lineLength,lineSpacing] as [NSNumber]
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: line.frame.width, y: 0))
        shapeLayer.path = path
        
        line.layer.addSublayer(shapeLayer)
    }
    
}
