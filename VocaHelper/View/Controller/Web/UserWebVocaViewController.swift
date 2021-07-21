//
//  UserWebVocaViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/07/18.
//

import UIKit
import RxSwift
import RxCocoa

class UserWebVocaViewController: UIViewController {
    deinit {
        print("deinit UserWebVocaView")
    }
    
    public var viewModel: WebViewModel?
    private var disposeBag = DisposeBag()
    
    let wordsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WebTableViewCell.self, forCellReuseIdentifier: WebTableViewCell.identifier)
        tableView.rowHeight = 240
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewConfigure()
        constraintsConfigure()
        rxConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func viewConfigure() {
        view.addSubview(wordsTableView)
    }
    
    private func constraintsConfigure() {
        wordsTableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        wordsTableView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        wordsTableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        wordsTableView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
    }
    
    private func rxConfigure() {
        guard let viewModel = viewModel else {
            print("view model nil")
            return
        }
        viewModel.makeUserUploadSubject()
        
        viewModel.userUploadVocaSubject
            .bind(to: wordsTableView.rx.items(cellIdentifier: WebTableViewCell.identifier, cellType: WebTableViewCell.self)) { [weak self] indexPath, item, cell in
                cell.titleLabel.text = item.title
                cell.descriptionLabel.text = item.description
                cell.writerLabel.text = item.writer
                cell.downloadLabel.text = String(item.download)
                cell.likeLabel.text = String(item.like)
                
                let likeImage = item.liked ? "hand.thumbsup.fill" : "hand.thumbsup"
                cell.likeButton.setImage(UIImage(systemName: likeImage), for: .normal)
                cell.tapFunction = { self?.viewModel?.getWebVocas(
                    email: item.email,
                    title: item.title,
                    isLiked: item.liked,
                    vocas: item.vocas,
                    view: self!)
                }
            }.disposed(by: disposeBag)
    }
}
