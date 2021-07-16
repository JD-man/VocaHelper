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
    
    let tabbarImages: [String] = ["book", "magnifyingglass.circle", "network", "gearshape"]
    let selectedTabbarImages: [String] = ["book.fill", "magnifyingglass.circle.fill", "network", "gearshape.fill"]
    
    let wordsNavVC: UINavigationController = {
        let nav = UINavigationController(rootViewController: WordsViewController())
        nav.navigationItem.title = "Words"
        return nav
    }()
    
    let searchNavVC: UINavigationController = {
        let nav = UINavigationController(rootViewController: SearchViewController())
        nav.navigationItem.title = "Search"
        return nav
    }()
    
    let webNavVC: UINavigationController = {
        let nav = UINavigationController(rootViewController: WebViewController())
        nav.navigationItem.title = "Web"
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
        setViewControllers([wordsNavVC, searchNavVC, webNavVC], animated: true)
        changeTabbarImage(title: "Words")
        
        rx.didSelect
            .bind() { [weak self] in                
                let title = $0.navigationItem.title ?? ""
                self?.changeTabbarImage(title: title)
                VocaManager.shared.makeAllVocasForSearch(title: title)
            }.disposed(by: disposeBag)
    }
    
    private func changeTabbarImage(title: String) {
        for (i,cv) in viewControllers!.enumerated() {
            if cv.navigationItem.title == title {
                cv.tabBarItem.image = UIImage(systemName: selectedTabbarImages[i])                
            }
            else {
                cv.tabBarItem.image = UIImage(systemName: tabbarImages[i])
            }
        }
    }
}
