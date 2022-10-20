//
//  String+Extension.swift
//  my_iPad
//
//  Created by my on 2021/11/18.
//

import Foundation
import UIKit

extension String {
    func heightWithWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect: CGRect = self.boundingRect(with: CGSize.init(width: width, height: 1000), options: option, attributes: attributes, context: nil)
        return rect.size.height
    }
    
    func widthWithHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect: CGRect = self.boundingRect(with: CGSize.init(width: 1000, height: height), options: option, attributes: attributes, context: nil)
        return rect.size.width
    }
    
    func sizeWithText(font: UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = self.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: option, attributes: attributes, context: nil)
            return rect.size;
    }
    
    func strikeLine(font: UIFont, color: UIColor) -> NSMutableAttributedString {
        let attriStr = NSMutableAttributedString(string: self)
        let range = NSRange(location: 0, length: self.count)
        attriStr.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSAttributedString.Key.underlineStyle, range: range)
        attriStr.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        attriStr.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        return attriStr
    }
    
    //是否是纯中文汉字
    func isPureChinese() -> Bool {
        let match = "^[\u{4e00}-\u{9fa5}]+$"
        let predicate = NSPredicate(format: "SELF matches %@", match)
        return predicate.evaluate(with: self)
    }
    //是否是纯英文
    func isPureEnglish() -> Bool {
        let match = "^[a-zA-Z]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", match)
        return predicate.evaluate(with: self)
    }
    
    //转换成拼音
    func transformToPinYin()->String{
        let mutableString = NSMutableString(string: self)
        //把汉字转为拼音
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        //去掉拼音的音标
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let string = String(mutableString)
        //去掉空格
        return  string.replacingOccurrences(of: " ", with: "")
    }
    
    func dateFrom(format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: self) ?? Date()
    }
}
