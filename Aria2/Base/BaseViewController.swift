import UIKit

class BaseViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var statusBarStyle: UIStatusBarStyle = .lightContent
    
    lazy var backItem: UIBarButtonItem! = {
        let item = UIBarButtonItem(image: UIImage(named: "naviBack"), style: .plain, target: self, action: #selector(popAction))
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self)

        // Do any additional setup after loading the view.
        view.backgroundColor = DefaultBackgroundColor
        
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        self.extendedLayoutIncludesOpaqueBars = false
        
    }
    
    
    @objc func popAction() {
        if (self.presentingViewController != nil) {
            if (self.navigationController != nil) && (self.navigationController?.viewControllers.count)! > 1 {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.statusBarStyle
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
