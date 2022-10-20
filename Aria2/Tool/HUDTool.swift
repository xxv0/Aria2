import UIKit


/// 黑底白字
class CustomHUDView: PKHUDWideBaseView {
    public init(text: String?) {
        super.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: ScreenWidth-80, height: 60.0)))
        commonInit(text)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit("")
    }

    func commonInit(_ text: String?) {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        titleLabel.text = text
        addSubview(titleLabel)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        let padding: CGFloat = 10.0
        titleLabel.frame = bounds.insetBy(dx: padding, dy: padding)
    }

    public let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white//UIColor.black.withAlphaComponent(0.85)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 3
        return label
    }()
}

/// 黑底白色Activity
class CustomActivityHUDView: PKHUDWideBaseView {
    public init(text: String?) {
        super.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: ScreenWidth-80, height: 60.0)))
        commonInit(text)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit("")
    }

    func commonInit(_ text: String?) {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        titleLabel.text = text
        addSubview(titleLabel)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        let padding: CGFloat = 10.0
        titleLabel.frame = bounds.insetBy(dx: padding, dy: padding)
    }

    public let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white//UIColor.black.withAlphaComponent(0.85)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 3
        return label
    }()
}

class HUDTool: NSObject {
    
    public static func customConfig() {
        PKHUD.sharedHUD.contentView.backgroundColor = UIColor(white: 0, alpha: 0.8)
    }
    
    public static func showHudIndeterminate() {
        DispatchQueue.main.async(execute: {
            HUD.show(.systemActivity)
        })
    }
    
    public static func showHudTextIndeterminate(text: String!) {
        DispatchQueue.main.async(execute: {
            HUD.show(.labeledProgress(title: text, subtitle: nil))
        })
    }
    
    public static func showHudText(text: String!) {
        DispatchQueue.main.async(execute: {
            HUD.flash(.label(text), delay: 2)
//            HUD.flash(.customView(view: CustomHUDView(text: text)), delay: 2)
        })
    }
    
    public static func showHudText(text: String!, callBack:(() -> Void)!) {
        DispatchQueue.main.async(execute: {
            HUD.flash(.label(text), onView: nil, delay: 1, completion: { (comp) in
                callBack()
            })
//            HUD.flash(.customView(view: CustomHUDView(text: text)), delay: 2, completion: { (comp) in
//                callBack()
//            })
        })
    }
    
    public static func hideHud() {
        DispatchQueue.main.async(execute: {
            HUD.hide()
        })
    }
 
}
