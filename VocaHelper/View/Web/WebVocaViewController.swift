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

class WebVocaViewController: EditBaseViewController {
    
    deinit {
        print("deinit WebVocaView")
    }
    
    public var webVocaName: String = ""
    public var isLiked: Bool = false
    
    lazy var viewModel = VocaViewModel(fileName: fileName)
    let disposeBag = DisposeBag()
    
    override func addBarButton() {
        navigationItem.leftBarButtonItem?.image =  UIImage(systemName: "arrowshape.turn.up.backward")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem()
        navigationItem.rightBarButtonItem?.image =  UIImage(systemName: "list.dash")
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    override func rxConfigure() {
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
                self?.viewModel.didTapWebVocaRightButton(webVocaName: self!.webVocaName, isLiked: self!.isLiked, view: self!)
            }.disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind { [weak self] in                
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
    }
}
