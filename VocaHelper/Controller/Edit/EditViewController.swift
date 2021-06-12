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
    private var selectedRow: Int = 0
    
    private var touchXPos : CGFloat = 0
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EditTableViewCell.self, forCellReuseIdentifier: EditTableViewCell.identifier)
        tableView.rowHeight = 100
        return tableView
    }()
    
    private let gesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addSubViews()
        addFooter()
        rxConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        gesture.addTarget(self, action: #selector(didTapTable))
        gesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gesture)
    }
    
    private func configure() {
        view.backgroundColor = .systemIndigo
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        navigationItem.leftBarButtonItem?.image =  UIImage(systemName: "arrowshape.turn.up.backward")
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "highlighter"), style: .plain, target: self, action: #selector(didTapRightButton))
    }
    
    private func addFooter() {
        let footer = EditTableViewFooter(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))
        tableView.tableFooterView = footer
    }
    
    private func addSubViews() {
        view.addSubview(tableView)
    }
    
    @objc private func didTapLeftButton() {
        
    }
    
    @objc private func didTapTable() {
        touchXPos = gesture.location(in: tableView).x
    }
    
    private func rxConfigure() {
        // 단어장에 단어표시
        viewModel.vocaSubject
            .bind(to: tableView.rx.items(cellIdentifier: EditTableViewCell.identifier,
                                         cellType: EditTableViewCell.self)) {row, item, cell in
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
                self?.viewModel.makeVocas(tableView: tableView, fileName: fileName, isNewLine: false)
                self?.tabBarController?.tabBar.isHidden.toggle()
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
                self?.viewModel.addNewLine(tableView: tableView, fileName: fileName, isNewLine: true)                
            }.disposed(by: disposeBag)
    }
}

//extension EditViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return vocaCount
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: EditTableViewCell.identifier, for: indexPath) as! EditTableViewCell
//        if let word = voca.vocas[indexPath.row]?.keys.first, let meaning = voca.vocas[indexPath.row]?.values.first {
//            cell.wordTextField.text = word
//            cell.meaningTextField.text = meaning
//            cell.delegate = self
//            return cell
//        } else {
//            cell.wordTextField.placeholder = "Word"
//            cell.meaningTextField.placeholder = "Meaning"
//            cell.delegate = self
//            return cell
//        }
//    }
//
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
//            self.vocaCount -= 1
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            self.voca.vocas.removeAll()
//            for i in 0..<self.vocaCount {
//                guard let cell = tableView.cellForRow(at: IndexPath.init(row: i, section: 0)) as? EditTableViewCell else{
//                    return
//                }
//                self.voca.vocas[i] = [cell.wordTextField.text!: cell.meaningTextField.text!]
//            }
//            tableView.reloadData()
//        }
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //tableView.deselectRow(at: indexPath, animated: true)
//        guard let cell = tableView.cellForRow(at: indexPath) as? EditTableViewCell else {
//            return
//        }
//        // 선택된 cell의 row를 가져올 필요가 있어서 cell에 textfield를 컨텐트뷰에서 빼고 그냥 뷰에 넣었음.
//        selectedRow = indexPath.row
//
//        // 당장은 제스쳐에 의한 touchXPos가 입력이 되지만 제스쳐와 didselect사이에서 뭐가 빠른지 모르겠음
//        // touchXPos가 제대로 들어오고 난 다음에 아래 코드들이 실행되도록 만들어야함
//        //print(touchXPos)
//
//        if touchXPos > tableView.bounds.width / 2 {
//            cell.meaningTextField.becomeFirstResponder()
//            cell.wordTextField.resignFirstResponder()
//        } else {
//            cell.wordTextField.becomeFirstResponder()
//            cell.meaningTextField.resignFirstResponder()
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        guard let cell = tableView.cellForRow(at: indexPath) as? EditTableViewCell else {
//            return
//        }
//        voca.vocas[selectedRow] = [cell.wordTextField.text! : cell.meaningTextField.text!]
//    }
//}

//extension EditViewController: EditTableViewFooterDelegate {
//    func addLine() {
////        //vocaCount += 1
////        let indexPath: IndexPath = IndexPath.init(row: vocaCount - 1, section: 0)
////        tableView.insertRows(at: [indexPath], with: .top)
////        tableView.scrollToRow(at: indexPath , at: .top, animated: true)
////        //voca.vocas[vocaCount - 1] = [ : ]
//    }
//}

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

