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
    lazy var viewModel = VocaViewModelList(fileName: fileName)    
    let disposeBag = DisposeBag()
    
    //private var vocaCount: Int = 0
    private var selectedRow: Int?
    
    private var touchXPos : CGFloat = 0
    
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
        viewModel.vocaSubject
            .bind(to: tableView.rx.items(cellIdentifier: EditTableViewCell.identifier,
                                         cellType: EditTableViewCell.self)) { row, item, cell in
                cell.wordTextField.text = item.word
                cell.meaningTextField.text = item.meaning
                
            }.disposed(by: disposeBag)
        
        // 뒤로가기 버튼
        navigationItem.leftBarButtonItem?.rx.tap
            .bind() { [weak self] in
                guard let tableView = self?.tableView,
                      let fileName = self?.fileName else {
                    return
                }
                if let row = self?.selectedRow {
                    guard let cell = tableView.cellForRow(at: IndexPath.init(row: row, section: 0)) as? EditTableViewCell else {
                        return
                    }
                    VocaManager.shared.vocas[row].word = cell.wordTextField.text ?? ""
                    VocaManager.shared.vocas[row].meaning = cell.wordTextField.text ?? ""
                }
                VocaManager.shared.saveVocas(fileName: fileName)
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        
        // 추가하기 버튼
        guard let footer = tableView.tableFooterView as? EditTableViewFooter else {
            return
        }
        
        footer.addButton.rx.tap
            .bind() { [weak self] in
                guard let tableView = self?.tableView,
                      let fileName = self?.fileName else {
                    return
                }
                if let row = self?.selectedRow {
                    guard let cell = tableView.cellForRow(at: IndexPath.init(row: row, section: 0)) as? EditTableViewCell else {
                        return
                    }
                    VocaManager.shared.vocas[row].word = cell.wordTextField.text ?? ""
                    VocaManager.shared.vocas[row].meaning = cell.wordTextField.text ?? ""
                }
                VocaManager.shared.vocas.append(Voca(word: "", meaning: ""))
                self?.viewModel.makeViewModelsFromVocas()
                let indexPath = IndexPath.init(row: tableView.numberOfRows(inSection: 0) - 1, section: 0)
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                VocaManager.shared.saveVocas(fileName: fileName)
            }.disposed(by: disposeBag)
        
        gesture.rx.event
            .bind { [weak self] in
                self?.touchXPos = $0.location(in: self?.tableView).x
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind() { [weak self] indexPath in
                self?.selectedRow = indexPath.row
                guard let cell = self?.tableView.cellForRow(at: indexPath) as? EditTableViewCell,
                      let width = self?.tableView.frame.size.width,
                      let touchXPos = self?.touchXPos else {
                    return
                }
                if touchXPos < width / 2{
                    print(VocaManager.shared.vocas.count)
                    cell.wordTextField.becomeFirstResponder()
                }
                else {
                    cell.meaningTextField.becomeFirstResponder()
                }
            }.disposed(by: disposeBag)
        
        tableView.rx.itemDeselected
            .bind() { [weak self] indexPath in
                guard let cell = self?.tableView.cellForRow(at: indexPath) as? EditTableViewCell,
                      let word = cell.wordTextField.text,
                      let meaning = cell.meaningTextField.text else {
                    return
                }
                VocaManager.shared.vocas[indexPath.row].word = word
                VocaManager.shared.vocas[indexPath.row].meaning = meaning
                self?.viewModel.makeViewModelsFromVocas()
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

