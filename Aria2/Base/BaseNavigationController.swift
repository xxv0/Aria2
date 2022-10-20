import UIKit

class BaseNavigationController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

//    lazy var backItem: UIBarButtonItem! = {
//        let item = UIBarButtonItem(image: UIImage(named: "naviBack"), style: .plain, target: self, action: #selector(popAction))
//        return item
//    }()
    
    var currentShowVC: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar.barTintColor = DefaultColor
        self.navigationBar.tintColor = .white
        self.navigationBar.isTranslucent = false
        self.modalPresentationStyle = .fullScreen
        
        
//        self.navigationBar.setBackgroundImage(gradientImage, for: .default)
        
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,
                                                  NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)]
        
        
        if #available(iOS 13.0, *) {
            let naviBarAppearance = UINavigationBarAppearance()
            naviBarAppearance.backgroundColor = DefaultColor
            var textAttributes: [NSAttributedString.Key: AnyObject] = [:]
            textAttributes[.foregroundColor] = UIColor.white
            textAttributes[.font] = UIFont.systemFont(ofSize: 18)
            naviBarAppearance.titleTextAttributes =  textAttributes
            naviBarAppearance.shadowColor = UIColor.clear
            self.navigationBar.scrollEdgeAppearance = naviBarAppearance
            self.navigationBar.standardAppearance = naviBarAppearance
        } else {
            
        }

        self.interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
    }
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController!.preferredStatusBarStyle
    }
    
//    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//
//        if self.viewControllers.count > 0 {
//            viewController.hidesBottomBarWhenPushed = true
//            viewController.navigationItem.leftBarButtonItem = backItem
//        }
//        super.pushViewController(viewController, animated: animated)
//    }
    
//    @objc func popAction() {
//        self.popViewController(animated: true)
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.count == 1 {
            currentShowVC = nil
        } else {
            currentShowVC = viewController
        }
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.interactivePopGestureRecognizer {
            return self.currentShowVC == self.topViewController
        }
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer is UIPanGestureRecognizer) && (otherGestureRecognizer is UIScreenEdgePanGestureRecognizer) {
            return true
        } else {
            return false
        }
    }
}
