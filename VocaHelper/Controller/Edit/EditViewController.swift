//
//  EditViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/24.
//

import UIKit

class EditViewController: UIViewController {
       
    public var voca = VocaData(vocas: [Int : [String : String]]())
    public var fileName: String = ""
    
    private var vocaCount: Int = 0
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EditTableViewCell.self, forCellReuseIdentifier: EditTableViewCell.identifier)        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addSubViews()
        addFooter()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        
        vocaCount = voca.vocas.count
    }
    
    private func configure() {
        view.backgroundColor = .systemIndigo
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward"), style: .plain, target: self, action: #selector(didTapLeftButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "highlighter"), style: .plain, target: self, action: #selector(didTapRightButton))
    }
    
    private func addFooter() {
        let footer = EditTableViewFooter(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))        
        footer.delegate = self
        tableView.tableFooterView = footer
    }
    
    private func addSubViews() {
        view.addSubview(tableView)
    }
    
    @objc private func didTapLeftButton() {
        makeVocas()
        saveVocas()
        tabBarController?.tabBar.isHidden = false
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapRightButton() {
        
    }
    
    private func makeVocas() {
        for i in 0 ..< vocaCount {
            let indexPath = IndexPath.init(row: i, section: 0)
            guard let cell = tableView.cellForRow(at: indexPath) as? EditTableViewCell,
                  let word = cell.wordTextField.text, let meaning = cell.meaningTextField.text else {
                return
            }
            voca.vocas[i] = [word : meaning]
        }
    }
    
    private func saveVocas() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            let path = directory.appendingPathComponent(fileName)            
            let data = try encoder.encode(voca)
            try data.write(to: path)
        } catch {
            print(error)
        }
    }
}

extension EditViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vocaCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditTableViewCell.identifier, for: indexPath) as! EditTableViewCell
        if let word = voca.vocas[indexPath.row]?.keys.first, let meaning = voca.vocas[indexPath.row]?.values.first {
            cell.wordTextField.text = word
            cell.meaningTextField.text = meaning
            cell.delegate = self
            return cell
        } else {
            cell.wordTextField.placeholder = "Word"
            cell.meaningTextField.placeholder = "Meaning"
            cell.delegate = self
            return cell
        }        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            self.vocaCount -= 1
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.voca.vocas.removeAll()

            for i in 0..<self.vocaCount {
                guard let cell = tableView.cellForRow(at: IndexPath.init(row: i, section: 0)) as? EditTableViewCell else{
                    return
                }
                self.voca.vocas[i] = [cell.wordTextField.text!: cell.meaningTextField.text!]
            }            
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension EditViewController: EditTableViewFooterDelegate {
    func addLine() {
        vocaCount += 1
        let indexPath: IndexPath = IndexPath.init(row: vocaCount-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .top)
        tableView.scrollToRow(at: indexPath , at: .top, animated: true)
        
    }
}

// 키보드가 텍스트필드를 가려서 추가한 델리게이트, 애니메이션

extension EditViewController: EditTableViewCellDelegate {
    func keyboardWillAppear() {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y -= 250
        }
    }
    
    func keyboardWillDisappear() {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y += 250
        }
    }
}

