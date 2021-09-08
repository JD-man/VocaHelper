//
//  EditBaseViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/09/01.
//

import UIKit

class EditBaseViewController: UIViewController {
    
    public var fileName: String = ""
    
    internal let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EditTableViewCell.self, forCellReuseIdentifier: EditTableViewCell.identifier)
        tableView.rowHeight = 100
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfigure()
        navigationConfigure()
        constraintConfigure()
        rxConfigure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden.toggle()
    }
    
    override func viewWillAppear(_ animated: Bool) {        
        tabBarController?.tabBar.isHidden.toggle()
    }
    
    internal func viewConfigure() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        addDetail()
    }
    
    internal func addDetail() {
        
    }
    
    internal func navigationConfigure() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        navigationItem.leftBarButtonItem?.tintColor = .label
        addBarButton()
    }
    
    internal func addBarButton() {
        navigationItem.leftBarButtonItem?.image =  UIImage(systemName: "arrowshape.turn.up.backward")
    }
    
    internal func constraintConfigure() {
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
    }
    
    internal func rxConfigure() {
    }
}
