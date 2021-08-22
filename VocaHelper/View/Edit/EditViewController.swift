//
//  EditViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class EditViewController: UIViewController {
    
    deinit {
        print("deinit editview")
    }
    
    public var fileName: String = ""
    
    lazy var viewModel = VocaViewModel(fileName: fileName)    
    let disposeBag = DisposeBag()
    
    private var prevTitle: String = ""
    private var selectedSection: Int?
    private var selectedCell: EditTableViewCell?
    
    private var touchXPos : CGFloat = 0
    private var tableViewConstraints: [NSLayoutConstraint] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EditTableViewCell.self, forCellReuseIdentifier: EditTableViewCell.identifier)
        tableView.rowHeight = 100
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var gesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotification()
        viewConfigure()        
        rxConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableViewConstraints = [
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor)
        ]
        NSLayoutConstraint.activate(tableViewConstraints)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func viewConfigure() {
        view.backgroundColor = .systemBackground
        
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
    
    private func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didHideKeyboard), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc private func willShowKeyboard(_ notification: Notification) {
        guard let info = notification.userInfo,
              let rect = info["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {
            return
        }
        NSLayoutConstraint.deactivate(tableViewConstraints)
        tableViewConstraints.removeLast()
        tableViewConstraints.append(
            tableView.heightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.heightAnchor,
                constant: -rect.height + view.safeAreaInsets.bottom)
        )
        NSLayoutConstraint.activate(tableViewConstraints)
        
        navigationItem.leftBarButtonItem?.isEnabled = false
        guard let footer = tableView.tableFooterView as? EditTableViewFooter else {
            return
        }
        footer.isUserInteractionEnabled = false
        footer.addButton.tintColor = .systemGray
    }
    
    @objc private func willHideKeyboard(_ notification: Notification) {
        NSLayoutConstraint.deactivate(tableViewConstraints)
        tableViewConstraints.removeLast()
        tableViewConstraints.append(
            tableView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor)
        )
        NSLayoutConstraint.activate(tableViewConstraints)
        
        navigationItem.leftBarButtonItem?.isEnabled = true
        guard let footer = tableView.tableFooterView as? EditTableViewFooter else {
            return
        }
        footer.isUserInteractionEnabled = true
        footer.addButton.tintColor = .systemGreen
    }
    
    @objc private func didHideKeyboard(_ notification: Notification) {
        viewModel.cellDeselected(section: selectedSection, cell: selectedCell)
    }
    
    private func rxConfigure() {
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<SectionOfEditCell>(animationConfiguration: AnimationConfiguration(insertAnimation: .top, reloadAnimation: .none, deleteAnimation: .fade)) { [weak self] dataSource, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditTableViewCell.identifier, for: indexPath) as? EditTableViewCell else {
                return UITableViewCell()
            }
            cell.wordTextField.text = item.word
            cell.meaningTextField.text = item.meaning
            cell.wordTextField.delegate = self ?? nil
            cell.meaningTextField.delegate = self ?? nil
            cell.selectionStyle = .none
            return cell
        }
        
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
            return true
        }
        
        viewModel.editCellSubject
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        // 뒤로가기 버튼
        navigationItem.leftBarButtonItem?.rx.tap
            .bind() { [weak self] in
                self?.viewModel.didTapBackButton(fileName: self?.fileName ?? "")
                self?.navigationController?.popViewController(animated: true)
                self?.tabBarController?.tabBar.isHidden.toggle()
            }.disposed(by: disposeBag)
        
        
        // 추가하기 버튼
        if let footer = tableView.tableFooterView as? EditTableViewFooter {
            footer.addButton.rx.tap
                .bind() { [weak self] in
                    self?.viewModel.didTapAddButton(fileName: self?.fileName ?? "", view: self!)
                    self?.tableView.scrollToRow(at: IndexPath.init(row: 0, section: VocaManager.shared.vocas.count - 1), at: .top, animated: true)
                }.disposed(by: disposeBag)
        }
        
        gesture.rx.event
            .bind { [weak self] in
                self?.touchXPos = $0.location(in: self?.tableView).x
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind() { [weak self] indexPath in                
                self?.selectedSection = indexPath.section
                self?.selectedCell = self?.tableView.cellForRow(at: indexPath) as? EditTableViewCell
                self?.viewModel.cellSelected(cell: self?.selectedCell, width: self?.tableView.frame.size.width, touchXPos: self?.touchXPos)
            }.disposed(by: disposeBag)
        
        tableView.rx.itemDeselected
            .bind() { [weak self] indexPath in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.viewModel.cellDeselected(section: strongSelf.selectedSection, cell: strongSelf.selectedCell)
            }.disposed(by: disposeBag)
        
        // 셀 삭제를 위한 델리게이트 설정
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}


// 셀 삭제를 위한 스와이프 액션
extension EditViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (_, _, _) in
            self?.viewModel.didDeleteCell(section: indexPath.section)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension EditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
