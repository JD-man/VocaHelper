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
    
    let tabbarImages: [String] = ["book", "magnifyingglass.circle"]
    
    let wordsNavVC: UINavigationController = {
        let nav = UINavigationController(rootViewController: WordsViewController())
        nav.title = "단어장"
        nav.tabBarItem.title = nil
        return nav
    }()
    
    let searchNavVC: UINavigationController = {
        let nav = UINavigationController(rootViewController: SearchViewController())        
        nav.title = "Search"
        nav.tabBarItem.title = nil
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
        changeTabbarImage(title: "")
        
        rx.didSelect
            .bind() { [weak self] in
                self?.changeTabbarImage(title: $0.title ?? "")
                VocaManager.shared.makeAllVocasForSearch(title: $0.title ?? "")                
            }.disposed(by: disposeBag)
    }
    
    private func changeTabbarImage(title: String) {
        for (i,cv) in viewControllers!.enumerated() {
            if cv.title == title {
                cv.tabBarItem.image = UIImage(systemName: tabbarImages[i] + ".fill")
            }
            else {
                cv.tabBarItem.image = UIImage(systemName: tabbarImages[i])
            }
        }
    }
}
