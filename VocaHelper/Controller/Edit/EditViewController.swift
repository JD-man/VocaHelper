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
    private var selectedRow: Int = 0
    
    private var touchXPos : CGFloat = 0
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EditTableViewCell.self, forCellReuseIdentifier: EditTableViewCell.identifier)
        return tableView
    }()
    
    private let gesture = UITapGestureRecognizer()
    
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
        
        gesture.addTarget(self, action: #selector(didTapTable))
        gesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gesture)
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
    
    @objc private func didTapTable() {
        touchXPos = gesture.location(in: tableView).x
        print(touchXPos)
    }
    
    private func makeVocas() {
        tableView.reloadData()
        for i in 0 ..< vocaCount {
            let indexPath = IndexPath(row: i, section: 0)
            
            // datasource로 모든셀에 접근할 수 있다.
            guard let cell = tableView.dataSource?.tableView(self.tableView, cellForRowAt: indexPath) as? EditTableViewCell else {
                return
            }
            // tableView에서 바로 cellForRow를 가져오면 보이는 셀까지만 접근한다.
//            guard let cell = tableView.cellForRow(at: indexPath) as? EditTableViewCell else {
//                return
//            }
            voca.vocas[i] = [cell.wordTextField.text! : cell.meaningTextField.text!]
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
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? EditTableViewCell else {
            return
        }
        // 선택된 cell의 row를 가져올 필요가 있어서 cell에 textfield를 컨텐트뷰에서 빼고 그냥 뷰에 넣었음.
        selectedRow = indexPath.row
        
        // 당장은 제스쳐에 의한 touchXPos가 입력이 되지만 제스쳐와 didselect사이에서 뭐가 빠른지 모르겠음
        // touchXPos가 제대로 들어오고 난 다음에 아래 코드들이 실행되도록 만들어야함        
        print(touchXPos)
        
        if touchXPos > tableView.bounds.width / 2 {
            cell.meaningTextField.becomeFirstResponder()
            cell.wordTextField.resignFirstResponder()
        } else {
            cell.wordTextField.becomeFirstResponder()
            cell.meaningTextField.resignFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? EditTableViewCell else {
            return
        }
        voca.vocas[selectedRow] = [cell.wordTextField.text! : cell.meaningTextField.text!]
    }
}

extension EditViewController: EditTableViewFooterDelegate {
    func addLine() {
        vocaCount += 1
        let indexPath: IndexPath = IndexPath.init(row: vocaCount - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .top)
        tableView.scrollToRow(at: indexPath , at: .top, animated: true)
        //voca.vocas[vocaCount - 1] = [ : ]
    }
}

// 키보드가 텍스트필드를 가려서 추가한 델리게이트, 애니메이션

extension EditViewController: EditTableViewCellDelegate {
    
    // 텍스트를 수정했을때 datasource를 수정해야하므로 vocas를 변경한다
    func reload(word: String, meaning: String) {
        voca.vocas[selectedRow] = [word : meaning]
    }
    
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

