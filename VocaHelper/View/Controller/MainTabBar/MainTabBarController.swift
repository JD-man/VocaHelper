//
//  MainTabBarController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/23.
//

import UIKit
import RxSwift
import RxCocoa

class MainTabBarController: UITabBarController {
    
    let disposeBag = DisposeBag()
    
    let wordsNavVC: UINavigationController = {
        let nav = UINavigationController(rootViewController: WordsViewController())
        nav.title = "Words"
        nav.tabBarItem.title = nil
        nav.tabBarItem.image = UIImage(systemName: "book")
        return nav
    }()
    
    let searchNavVC: UINavigationController = {
        let nav = UINavigationController(rootViewController: SearchViewController())        
        nav.title = "Search"
        nav.tabBarItem.title = nil
        nav.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle")
        return nav
    }()
    
    let launchView: UIView = {
        guard let launchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController(),
              let launchView = launchScreen.view else {
            return UIView()
        }
        return launchView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLaunchScreen(1, 0.5)
        configure()        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func showLaunchScreen(_ sleepTime: UInt32, _ duration: TimeInterval) {
        view.addSubview(launchView)
        launchView.frame = view.bounds
        sleep(sleepTime)
        UIView.animate(withDuration: duration) { [weak self] in
            self?.launchView.alpha = 0.0
        }
    }
    
    private func configure() {
        tabBar.barTintColor = .systemBackground
        tabBar.tintColor = .label
        setViewControllers([wordsNavVC, searchNavVC], animated: true)
        rx.didSelect
            .bind() {
                switch $0.title ?? "" {
                case "Words":
                    $0.tabBarItem.image = UIImage(systemName: "book.fill")
                case "Search":
                    $0.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle.fill")
                default:
                    print("Selected Tabbar Title is not exist")
                }
                VocaManager.shared.makeAllVocasForSearch(title: $0.title ?? "")
            }.disposed(by: disposeBag)
    }
}
