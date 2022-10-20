import UIKit
import PKHUD

class MyTool: NSObject {
    static func speedStr(_ speed: Int = 0) -> String {
        let kb = speed/1024
        let mb = kb/1024
        let gb = mb/1024
        if gb > 0 {
            return "\(gb)GB/s"
        } else if mb > 0 {
            return "\(mb)MB/s"
        } else if kb > 0 {
            return "\(kb)KB/s"
        }
        return "0KB/s"
    }

    static func fileLengthUnitToShow(_ length: Int) -> String {
        let kb = length/1024
        let mb = kb/1024
        let gb = mb/1024
        
        if gb > 0 {
            return "\(gb)GB"
        } else if mb > 0 {
            return "\(mb)MB"
        } else if kb > 0 {
            return "\(kb)KB"
        }
        
        return "0KB"
    }
    
    
    
    
    /// 验证手机号
    ///
    /// - Parameter phone: phone
    /// - Returns: true/false
    static func validatePhone(_ phone: String) -> Bool {
        let phoneRegex = "^1[0-9]{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@",phoneRegex)
        return predicate.evaluate(with: phone)
    }
    
    /// 验证邮箱
    ///
    /// - Parameter email: email
    /// - Returns: true/false
    static func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@",emailRegex)
        return predicate.evaluate(with: email)
    }
    
    /// 验证密码6-20位
    ///
    /// - Parameter password: password
    /// - Returns: true/false
    static func validatePassword(_ password: String) -> Bool {
        let passwordRegex = "^(?![0-9]+$)(?![a-zA-Z]+$)[A-Za-z0-9]{6,20}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@",passwordRegex)
        return predicate.evaluate(with: password)
    }
    
    
    /// 是否有效价格
    /// - Parameter str: str
    /// - Returns: true/false
    static func validateMoney(str: String) -> Bool {
        var money = str
        if money.last == "." {
            money.removeLast()
        }
        let predicate0 = NSPredicate(format: "SELF MATCHES %@", "^[0][0-9]+$")
        let predicate1 = NSPredicate(format: "SELF MATCHES %@", "^(([0-9]|([1-9][0-9]{0,9}))((\\.[0-9]{1,2})?))$")
        //
        return !predicate0.evaluate(with: money) && predicate1.evaluate(with: money) ? true : false
    }
    
    /// DictionaryToString
    /// - Parameter dict: Dictionary
    /// - Returns: json string
    static func convertDictionaryToString(dict:[String:Any]) -> String {
        var result:String = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0))

            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                result = JSONString
            }
            
        } catch {
            result = ""
        }
        return result
    }
    
    /// StringToDictionary
    /// - Parameter jsonString: json string
    /// - Returns: Dictionary
    static func getDictionaryFromJSONString(jsonString:String) -> Dictionary<String, Any> {
     
        let jsonData:Data = jsonString.data(using: .utf8)!
     
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! Dictionary
        }
        return Dictionary()
    }
    
    /// StringToNSArray
    /// - Parameter jsonString: json string
    /// - Returns: NSArray
    static func jsonToArray(jsonString: String) -> NSArray {
        do {
            let data = jsonString.data(using: .utf8)!
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            return json as! NSArray
        } catch {
            return []
        }
    }
    
    static func noWhiteSpaceString(_ string: inout String) -> String {
        string = string.trimmingCharacters(in: .whitespacesAndNewlines)
        string = string.replacingOccurrences(of: " ", with: "")
        string = string.replacingOccurrences(of: "\r", with: "")
        string = string.replacingOccurrences(of: "\n", with: "")
        
        return string
    }
    
    // MARK: 弹窗配置
    /// 弹窗，提示框
    /// - Parameter isFadeAnimation: 提示框是渐变，弹窗是默认动画
    /// - Returns: config
    static func commonAlertViewAttributes(isFadeAnimation: Bool) -> EKAttributes {
        var attributes = EKAttributes()
        attributes.position = .center
        attributes.displayDuration = .infinity
        attributes.entryBackground = .color(color: .clear)
        attributes.screenBackground = .color(color: EKColor(UIColor(white: 0.0, alpha: 0.6)))
        //attributes.screenBackground = .color(color: UIColor(white: 0.0, alpha: 0.7))
        attributes.entryInteraction = .absorbTouches
        attributes.screenInteraction = .dismiss//.absorbTouches
        attributes.roundCorners = .all(radius: 12)
        attributes.scroll = .disabled
        if isFadeAnimation {
            //默认进出效果是从底部进出到中间
            attributes.entranceAnimation = EKAttributes.Animation.init(fade: .init(from:0.8, to:1.0, duration: 0.2))
            attributes.exitAnimation = EKAttributes.Animation.init(fade: .init(from:1.0, to:0.8, duration: 0.2))
            attributes.entryBackground = .color(color: .white)
        }
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.2)))
        attributes.positionConstraints.size = .init(width: .offset(value: 30), height: .intrinsic)
        attributes.positionConstraints.maxSize = .init(width: .offset(value: 30), height: .intrinsic)
        //为了hud显示在最上层
        attributes.windowLevel = .custom(level: UIApplication.shared.keyWindow!.windowLevel+1)
        
        return attributes
    }
    
    
    //格式是   原价：999元
    static func throughLineString(text: String) -> NSMutableAttributedString {
        let priceString = NSMutableAttributedString.init(string: text)
        priceString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber.init(value: 1), range: NSRange(location:0, length: priceString.length))
        
        return priceString
    }
    
    //double类型的价格取整，防止出现x.y99999999，返回字符串
    static func makePriceAccuracy(price: Double) -> String {
        let handler = NSDecimalNumberHandler(roundingMode: .plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        let priceNumber = NSDecimalNumber(value: price)
        let accuracyMoney = priceNumber.multiplying(by: 1, withBehavior: handler)
        return accuracyMoney.stringValue
    }
    
    //算价格，乘法
    static func multiplyPrice(_ price: Double, factor: Double) -> String {
        let handler = NSDecimalNumberHandler(roundingMode: .plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        let priceNumber = NSDecimalNumber(value: price)
        let factorNumber = NSDecimalNumber(value: price)
        let accuracyMoney = priceNumber.multiplying(by: factorNumber, withBehavior: handler)
        return accuracyMoney.stringValue
    }

    static func isPureInt(str: String) -> Bool {
        let scan = Scanner(string: str)
        var val: Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
        
    }
    
    static func isPureDouble(str: String) -> Bool {
        let scan = Scanner(string: str)
        var val: Double = 0.0
        return scan.scanDouble(&val) && scan.isAtEnd
    }
    
//    - (BOOL)isPureInt:(NSString*)string{
//        NSScanner* scan = [NSScanner scannerWithString:string];
//
//        int val;
//
//        return[scan scanInt:&val] && [scan isAtEnd];
//
//    }

    //MARK: - 生成二维码
    static func creatQRCodeImage(text: String, WH: CGFloat) -> UIImage {
        
        //创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        //还原滤镜的默认属性
        filter?.setDefaults()
        //设置需要生成二维码的数据
        filter?.setValue(text.data(using: String.Encoding.utf8), forKey: "inputMessage")
        //从滤镜中取出生成的图片
        let ciImage = filter?.outputImage
        //这个清晰度好
        let bgImage = createNonInterpolatedUIImageFormCIImage(image: ciImage!, size: WH)
        
        return bgImage
    }
    
    static func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = image.extent.integral
        let scale: CGFloat = min(size/extent.width, size/extent.height)

        let width = extent.width * scale
        let height = extent.height * scale
        
        
//        let width = size
//        let height = size
        
        
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: extent)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: scale, y: scale)
        bitmapRef.draw(bitmapImage, in: extent)
        let scaledImage: CGImage = bitmapRef.makeImage()!
        return UIImage(cgImage: scaledImage)
    }
}


extension Date {
    func stringWith(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    /// 获取当前的时间戳，精确到毫秒
    /// - Returns: timestamp
    func getNowTimeTimestamp() -> String {
        let timeStamp = String(self.timeIntervalSince1970*1000)
        return timeStamp
    }
    
    func compareDate(_ date:Date) -> Bool {
        
        return false
    }
    
    /// 获取当前时区时间
    func getLocalTimeZoneDate() -> Date {
        let zone = TimeZone.current
        let time: TimeInterval = TimeInterval(zone.secondsFromGMT(for: self))
        return self.addingTimeInterval(time)
    }
    
    /// 没有时分秒的日期
    ///
    /// - Returns: 没有时分秒的date
    func dateWithOutHMS()-> Date {
        let calendar = NSCalendar.current
        return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self)!.getLocalTimeZoneDate()
    }
    
    /// 获取两个日期差
    ///
    /// - Parameter date: 从哪天开始
    /// - Returns: 相差天数
    func daysFrom(date: Date!) -> Int {
        let timeZone = NSTimeZone.system
        let interval1 = timeZone.secondsFromGMT(for: date)
        let date1 = date.addingTimeInterval(TimeInterval(interval1))
        let interval2 = timeZone.secondsFromGMT(for: self)
        var date2 = self.addingTimeInterval(TimeInterval(interval2))
        date2 = date2.dateWithOutHMS()
        
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone.system
//        let toDate = calendar.startOfDay(for: date1)
//        let fromDate = calendar.startOfDay(for: date2)
        let components = calendar.dateComponents([.day], from: date2, to: date1)
        return (components.day!)
    }
    
    //计算年龄，x岁y月的格式
    func calculateAge(_ birthday: Date) -> String {
        
        let zone = TimeZone.current
        let interval = Double(zone.secondsFromGMT(for: self))
        let lastDate = birthday.addingTimeInterval(interval)

        return ageWithLocalDate(lastDate)
    }
    
    //本地时区的年龄
    private func ageWithLocalDate(_ date: Date) -> String {
        
        //出生年月日
        var components1 = Calendar.current.dateComponents([.year], from: date)
        let birthYear = components1.year!
        
        components1 = Calendar.current.dateComponents([.month], from: date)
        let birthMonth = components1.month!
        
        components1 = Calendar.current.dateComponents([.day], from: date)
        let birthDay = components1.day!
        
        //当前年月日
        var currentDate = Date()
        let zone = TimeZone.current
        let interval = Double(zone.secondsFromGMT(for: self))
        currentDate = self.addingTimeInterval(interval)
        
        var components2 = Calendar.current.dateComponents([.year], from: currentDate)
        let currentYear = components2.year!
        
        components2 = Calendar.current.dateComponents([.month], from: currentDate)
        let currentMonth = components2.month!
        
        components2 = Calendar.current.dateComponents([.day], from: currentDate)
        let currentDay = components2.day!
        
        //判断如果修改了系统时间返回0
        if currentYear < birthYear {
            return "0岁"
        }
        
        if currentYear == birthYear && currentMonth < birthMonth {
            return "0岁"
        }
        
        if currentYear == birthYear && currentMonth == birthMonth && currentDay < birthDay {
            return "0岁"
        }
        
        //下面是正常情况计算
        var age = currentYear - birthYear
        var month = currentMonth - birthMonth
        let day = currentDay - birthDay
        if day < 0 {
            if month == 0  {
                age -= 1
                month = 11
            } else {
                month -= 1
            }
        }
        
        if month < 0 {
            age -= 1
            month = month + 12
        }
        
        if age == 0 {
            if month == 1 || month == 0{
                return "新生儿"
            }
            return String(format: "%d个月", month)
        }
        
        return String(format: "%d岁%d个月", age, month)
    }
    
    
    /// 之后几天的日期字符串
    ///
    /// - Parameter days: 之后几天
    /// - Returns: 日期字符串 00.00
//    func stringDateAfterDays(_ days: Int) -> String {
//        let pureDate = self.dateWithOutHMS()
//        let newDate = pureDate.addingTimeInterval(Double(days)*OneDay)
//        return newDate.stringWith(format: "MM.dd")
//    }
}

//// MARK: 渐变
//extension CAGradientLayer {
//    //上下渐变
//    func gradientLayer() -> CAGradientLayer {
//        //定义渐变的颜色
//        let gradientColors = [DefaultColor.cgColor,
//                              UIColor(hex: "00d777").cgColor]
//        
//        //定义每种颜色所在的位置
//        let gradientLocations:[NSNumber] = [0.0, 1.0]
//        
//        //创建CAGradientLayer对象并设置参数
//        self.colors = gradientColors
//        self.locations = gradientLocations
//        
//        self.startPoint = CGPoint(x: 0, y: 0)
//        self.endPoint = CGPoint(x: 0, y: 1)
//        
//        return self
//    }
//}

extension CAGradientLayer {
    
    // 自动布局无效，需要设置frame
    /// 👉或👇的两种颜色渐变
    /// - Parameter colors: 两种颜色
    /// - Returns: layer
    func gradientLayerWithColors(_ colors: Array<CGColor>, directionHorizontal: Bool) -> CAGradientLayer {
        self.colors = colors
        self.locations = [0.0, 1.0]
        
        if directionHorizontal {
            self.startPoint = CGPoint(x: 0, y: 0)
            self.endPoint = CGPoint(x: 1, y: 0)
        } else {
            self.startPoint = CGPoint(x: 0, y: 0)
            self.endPoint = CGPoint(x: 0, y: 1)
        }
        return self
    }
}

extension Double {
    ///四舍五入 到小数点后某一位
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    ///截断  到小数点后某一位
    func truncate(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Double(Int(self * divisor)) / divisor
    }
}

extension Array {
    // 去重
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}


extension UIAlertController {
    func set(vc: UIViewController?, width: CGFloat? = nil, height: CGFloat? = nil) {
        guard let vc = vc else { return }
        setValue(vc, forKey: "contentViewController")
        if let height = height {
            vc.preferredContentSize.height = height
            preferredContentSize.height = height
        }
    }
    /// Add a textField
        ///
        /// - Parameters:
        ///   - height: textField height
        ///   - hInset: right and left margins to AlertController border
        ///   - vInset: bottom margin to button
        ///   - configuration: textField
        
    func addOneTextField(configuration: TextField.Config?) {
        let textField = OneTextFieldViewController(vInset: preferredStyle == .alert ? 12 : 0, configuration: configuration)
        let height: CGFloat = OneTextFieldViewController.ui.height + OneTextFieldViewController.ui.vInset
        set(vc: textField, height: height)
    }
    
    static func showTextFieldAlert(title: String = "提示", textFieldText: String = "", keyboardType: UIKeyboardType = .default, in viewController:UIViewController, in view: UIView, confirm: @escaping (String) -> ()) {
        var textStr = textFieldText
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let config: TextField.Config = { textField in
            textField.becomeFirstResponder()
            textField.textColor = .black
            textField.text = textFieldText
            textField.placeholder = "请输入"
            textField.textAlignment = .center
//            textField.left(image: image, color: .black)
//            textField.leftViewPadding = 12
//            textField.borderWidth = 1
//            textField.cornerRadius = 8
//            textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
            textField.goodCornerRadius(radius: 5)
            textField.setborder(withColor: UIColor.lightGray.withAlphaComponent(0.5), withWidth: 1)
            textField.backgroundColor = nil
            textField.keyboardAppearance = .default
            textField.keyboardType = keyboardType
            textField.isSecureTextEntry = false
            textField.returnKeyType = .done
            textField.action { textField in
                // validation and so on
                textStr = textField.text ?? ""
            }
        }
        alert.addOneTextField(configuration: config)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { action in
            confirm(textStr)
        }))
        let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
        if isPad {
            let popPresenter = alert.popoverPresentationController
            popPresenter?.sourceView = view
            popPresenter?.sourceRect = view.bounds
        }
        
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showTextFieldAlert(title: String = "提示", in viewController:UIViewController, in view: UIView, confirm: @escaping (String) -> ()) {
        
        showTextFieldAlert(title: title, textFieldText: "", keyboardType: .default, in: viewController, in: view, confirm: confirm)
    }
}

open class TextField: UITextField {
    
    public typealias Config = (TextField) -> Swift.Void
    
    public func configure(configurate: Config?) {
        configurate?(self)
    }
    
    public typealias Action = (UITextField) -> Void
    
    fileprivate var actionEditingChanged: Action?
    
    // Provides left padding for images
    
    override open func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftViewPadding ?? 0
        return textRect
    }
    
//    override open func textRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.insetBy(dx: (leftTextPadding ?? 8) + (leftView?.width ?? 0) + (leftViewPadding ?? 0), dy: 0)
//    }
//
//    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.insetBy(dx: (leftTextPadding ?? 8) + (leftView?.width ?? 0) + (leftViewPadding ?? 0), dy: 0)
//    }
    
    
    public var leftViewPadding: CGFloat?
    public var leftTextPadding: CGFloat?
    
    
    public func action(closure: @escaping Action) {
        if actionEditingChanged == nil {
            addTarget(self, action: #selector(TextField.textFieldDidChange), for: .editingChanged)
        }
        actionEditingChanged = closure
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        actionEditingChanged?(self)
    }
}


final class OneTextFieldViewController: UIViewController {
    
    fileprivate lazy var textField: TextField = TextField()
    
    struct ui {
        static let height: CGFloat = 44
        static let hInset: CGFloat = 12
        static var vInset: CGFloat = 12
    }
    
    
    init(vInset: CGFloat = 12, configuration: TextField.Config?) {
        super.init(nibName: nil, bundle: nil)
        view.addSubview(textField)
        ui.vInset = vInset
        
        /// have to set textField frame width and height to apply cornerRadius
        textField.frame.size.height = 40
        textField.frame.size.width = 250
        
        configuration?(textField)
        
        preferredContentSize.height = ui.height + ui.vInset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        textField.frame.size.height = 40
        textField.frame.size.width = 250
        textField.center.x = view.center.x
        textField.center.y = view.center.y - ui.vInset / 2
    }
}
