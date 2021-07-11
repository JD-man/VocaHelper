//
//  WebVocaViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/07/09.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class WebVocaViewController: UIViewController {
    
    deinit {
        print("deinit WebVocaView")
    }
    
    public var fileName: String = ""
    
    lazy var viewModel = VocaViewModel(fileName: fileName)
    let disposeBag = DisposeBag()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EditTableViewCell.self, forCellReuseIdentifier: EditTableViewCell.identifier)
        tableView.rowHeight = 100
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfigure()
        rxConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func viewConfigure() {
        navigationItem.rightBarButtonItem = UIBarButtonItem()
        navigationItem.rightBarButtonItem?.image =  UIImage(systemName: "list.dash")
        
        view.backgroundColor = .systemIndigo
        view.addSubview(tableView)
    }
    
    private func rxConfigure() {
        let dataSource = RxTableViewSectionedAnimatedDataSource<SectionOfEditCell>(animationConfiguration: AnimationConfiguration(insertAnimation: .top, reloadAnimation: .none, deleteAnimation: .fade)) { dataSource, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditTableViewCell.identifier, for: indexPath) as? EditTableViewCell else {
                return UITableViewCell()
            }
            cell.wordTextField.text = item.word
            cell.meaningTextField.text = item.meaning
            cell.selectionStyle = .none
            return cell
        }
        
        viewModel.editCellSubject
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .bind { [weak self] in
                print("hh")
                self?.viewModel.pushWebVocaExamViewController(view: self!)
            }.disposed(by: disposeBag)
    }
}
