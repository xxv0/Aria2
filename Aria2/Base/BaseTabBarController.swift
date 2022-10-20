//
//  BaseTabBarController.swift
//  my_iPad
//
//  Created by my on 2022/8/26.
//

import UIKit

class BaseTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = DefaultColor
        self.delegate = self
        
        let vc0 = DownloadRootViewController()
        vc0.tabBarItem = UITabBarItem(title: "任务", image: UIImage(named: "tabbar_download"), tag: 0)
        let navi0 = BaseNavigationController(rootViewController: vc0)
        navi0.tabBarItem.title = "任务"
        
        let vc1 = SettingViewController()
        vc1.tabBarItem = UITabBarItem(title: "设置", image: UIImage(named: "tabbar_setting"), tag: 1)
        let navi1 = BaseNavigationController(rootViewController: vc1)
        navi1.tabBarItem.title = "设置"
        
        self.viewControllers = [navi0, navi1]
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
