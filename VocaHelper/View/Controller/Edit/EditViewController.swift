//
//  EditViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/24.
//

import UIKit
import RxSwift
import RxCocoa


class EditViewController: UIViewController {
    
    deinit {
        print("deinit editview")
    }
    
    public var fileName: String = ""
    lazy var viewModel = VocaViewModel(fileName: fileName)    
    let disposeBag = DisposeBag()
    
    //private var vocaCount: Int = 0
    private var selectedRow: Int?
    private var selectedCell: EditTableViewCell?
    
    private var touchXPos : CGFloat = 0
    
    private var isKeyboardMoving: Bool = false
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EditTableViewCell.self, forCellReuseIdentifier: EditTableViewCell.identifier)
        tableView.rowHeight = 100
        return tableView
    }()
    
    private var gesture = UITapGestureRecognizer()
    
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
        view.backgroundColor = .systemIndigo
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        navigationItem.leftBarButtonItem?.image =  UIImage(systemName: "arrowshape.turn.up.backward")
        
        let footer = EditTableViewFooter(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))
        tableView.tableFooterView = footer
        
        gesture = UITapGestureRecognizer()
        gesture.cancelsTouchesInView = false        
        tableView.addGestureRecognizer(gesture)
        view.addSubview(tableView)
    }
    
    private func rxConfigure() {
        // 단어장에 단어표시
        viewModel.editCellSubject
            .bind(to: tableView.rx.items(cellIdentifier: EditTableViewCell.identifier,
                                         cellType: EditTableViewCell.self)) { row, item, cell in
                cell.wordTextField.text = item.word
                cell.meaningTextField.text = item.meaning
                
            }.disposed(by: disposeBag)
        
        // 뒤로가기 버튼
        navigationItem.leftBarButtonItem?.rx.tap
            .bind() { [weak self] in
                self?.viewModel.didTapBackButton(row: self?.selectedRow, cell: self?.selectedCell, fileName: self?.fileName ?? "")
                self?.navigationController?.popViewController(animated: true)
                self?.tabBarController?.tabBar.isHidden.toggle()
            }.disposed(by: disposeBag)
        
        
        // 추가하기 버튼
        if let footer = tableView.tableFooterView as? EditTableViewFooter {
            footer.addButton.rx.tap
                .bind() { [weak self] in
                    self?.viewModel.didTapAddButton(row: self?.selectedRow, cell: self?.selectedCell, fileName: self?.fileName ?? "")
                    self?.tableView.scrollToRow(at: IndexPath.init(row: VocaManager.shared.vocas.count - 1, section: 0), at: .top, animated: true)
                }.disposed(by: disposeBag)
        }
        
        gesture.rx.event
            .bind { [weak self] in
                self?.touchXPos = $0.location(in: self?.tableView).x
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind() { [weak self] indexPath in
                self?.selectedRow = indexPath.row
                self?.selectedCell = self?.tableView.cellForRow(at: indexPath) as? EditTableViewCell                
                self?.viewModel.cellSelected(cell: self?.selectedCell, width: self?.tableView.frame.size.width, touchXPos: self?.touchXPos)
            }.disposed(by: disposeBag)
        
        tableView.rx.itemDeselected
            .bind() { [weak self] indexPath in
                self?.viewModel.cellDeselected(row: self?.selectedRow, cell: self?.selectedCell)
            }.disposed(by: disposeBag)
        
        // 셀 삭제를 위한 델리게이트 설정
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

// 셀 삭제를 위한 스와이프 액션
extension EditViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, _) in
            VocaManager.shared.vocas.remove(at: indexPath.row)
            self?.viewModel.makeViewModelsFromVocas()
            self?.selectedRow = nil
            self?.selectedCell = nil
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}


// 키보드가 텍스트필드를 가려서 추가한 델리게이트, 애니메이션

//extension EditViewController: EditTableViewCellDelegate {
//
//    // 텍스트를 수정했을때 datasource를 수정해야하므로 vocas를 변경한다
//    func reload(word: String, meaning: String) {
//        //voca.vocas[selectedRow] = [word : meaning]
//    }
//
//    func keyboardWillAppear() {
//        UIView.animate(withDuration: 0.3) {
//            self.view.frame.origin.y -= 250
//        }
//    }
//
//    func keyboardWillDisappear() {
//        UIView.animate(withDuration: 0.3) {
//            self.view.frame.origin.y += 250
//        }
//    }
//}

