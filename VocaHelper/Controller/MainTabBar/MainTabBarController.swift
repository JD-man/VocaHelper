//
//  MainTabBarController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/23.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let wordsNavVC: UINavigationController = {
        let nav = UINavigationController(rootViewController: WordsViewController())
        nav.tabBarItem.title = "Words"
        nav.tabBarItem.image = UIImage(systemName: "book")
        return nav
    }()
    
    let searchNavVC: UINavigationController = {
        let nav = UINavigationController(rootViewController: SearchViewController())
        nav.tabBarItem.title = "Search"
        nav.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        return nav
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func configure() {
        setViewControllers([wordsNavVC, searchNavVC], animated: true)        
    }
}
