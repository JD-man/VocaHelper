//
//  WordsViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/23.
//

import UIKit

class WordsViewController: UIViewController {
    
    private var collectionView:  UICollectionView?
    
    // 파일개수
    private var fileNames: [String] = []
    private var fileCount: Int = 0
    
    // MARK: - Popup Closure
    
    private var editClosure: (() -> EditViewController)?
    private var practiceClosure: (() -> PracticeViewController)?
    private var deleteClosure: (() -> Void)?
    private var cancelClosure: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        fileLoad()
    }
    
    private func configure() {
        navigationItem.title = "Words"
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: view.bounds.width/3-15, height: view.bounds.width/3-20)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(WordsCollectionViewCell.self, forCellWithReuseIdentifier: WordsCollectionViewCell.identifier)
        collectionView?.register(AddCollectionViewCell.self, forCellWithReuseIdentifier: AddCollectionViewCell.identifier)
        collectionView?.backgroundColor = .systemBackground
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(collectionView)
    }
    
    private func fileLoad() {
        let fileManager = FileManager.default
        guard let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        do {
            fileNames = try fileManager.contentsOfDirectory(atPath: directory.path)
            if fileNames.contains(".DS_Store") {
                guard let dsStoreIdx =  fileNames.firstIndex(of: ".DS_Store") else {
                    return
                }
                fileNames.remove(at: dsStoreIdx)
                fileNames.sort()
            }
            fileCount = fileNames.count            
        }
        catch {
            print(error)
        }
    }
}

extension WordsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileCount + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == fileCount {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCollectionViewCell.identifier, for: indexPath) as! AddCollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordsCollectionViewCell.identifier, for: indexPath) as! WordsCollectionViewCell
            let realName = fileNames[indexPath.row]
            cell.label.text = String(realName[realName.index(realName.startIndex, offsetBy: 25) ..< realName.endIndex])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        // Action Sheet이 아닌 Custom PopUp View를 만들었음
        // 단어장셀 터치시
        if let cell = collectionView.cellForItem(at: indexPath) as? WordsCollectionViewCell {
            UIView.animate(withDuration: 0.2) {
                cell.backgroundColor = .systemGray5
                cell.backgroundColor = .systemBackground                
            }
            let popupVC = PopupViewController()
            popupVC.delegate = self
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.textField.text = cell.label.text
            
            // edit 터치시 실행될 클로져
            editClosure = { () -> EditViewController in
                let editVC = EditViewController()
                
                // 저장파일을 가져와야함
                let decoder = JSONDecoder()
                let path = directory.appendingPathComponent(self.fileNames[indexPath.row])
                do {
                        let data = try Data(contentsOf: path)
                        editVC.voca = try decoder.decode(VocaData.self, from: data)
                    } catch {
                    print(error)
                }
                editVC.navigationItem.title = popupVC.textField.text
                editVC.fileName = self.fileNames[indexPath.row]
                return editVC
            }
            
            // practice 터치시 실행될 클로져
            
            practiceClosure = { ()-> PracticeViewController in
                let practiceVC = PracticeViewController()
                
                // 저장파일을 가져오기
                let decoder = JSONDecoder()
                let path = directory.appendingPathComponent(self.fileNames[indexPath.row])
                do {
                        let data = try Data(contentsOf: path)
                    practiceVC.voca = try decoder.decode(VocaData.self, from: data)
                    } catch {
                    print(error)
                }
                practiceVC.navigationItem.title = popupVC.textField.text
                return practiceVC
            }
            
            // delete 터치시 실행될 클로져
            deleteClosure = { () -> Void in
                self.fileCount -= 1
                collectionView.deleteItems(at: [indexPath])
                let path = directory.appendingPathComponent(self.fileNames[indexPath.row])
                self.fileNames.remove(at: indexPath.row)                
                if let error = try? FileManager.default.removeItem(atPath: path.path) {
                    print(error)
                } else {
                    return
                }
                return }
            
            // exit 터치시 실행될 클로져
            cancelClosure = { () -> Void in
                guard let fileName = popupVC.textField.text else {
                    return
                }
                //change file name
                let realName = self.fileNames[indexPath.row]
                let datePart = String(realName[realName.startIndex ..< realName.index(realName.startIndex, offsetBy: 25)])
                let currRealName = datePart + fileName
                
                let prevName = directory.appendingPathComponent(self.fileNames[indexPath.row]).path
                let currName = directory.appendingPathComponent(currRealName).path
                
                do {
                    try FileManager.default.moveItem(atPath: prevName, toPath: currName)
                } catch {
                    print(error)
                }
                
                cell.label.text = fileName
                self.fileNames[indexPath.row] = currRealName
                //print(self.fileNames)
                return
            }
            
            tabBarController?.tabBar.isHidden = true
            self.present(popupVC, animated: true, completion: nil)
            }
            
            // 추가하기 셀
            else {
            if let cell = collectionView.cellForItem(at: indexPath) as? AddCollectionViewCell {
                
                UIView.animate(withDuration: 0.2) {
                    cell.backgroundColor = .systemGray6
                    cell.backgroundColor = .systemBackground
                }
                fileNames.append("\(Date())Name")
                fileCount = fileNames.count
                // 빈 파일 하나 추가
                let newVocaData = VocaData(vocas: [Int : [String : String]]())
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                do {                    
                    print(directory)
                    let path = directory.appendingPathComponent("\(Date())Name")
                    let data = try encoder.encode(newVocaData)
                    try data.write(to: path)
                    } catch {
                    print(error)
                }
                 
                // 컬렉션뷰에 셀추가
                collectionView.insertItems(at: [indexPath])
            } else { return } }
    }
}

extension WordsViewController: PopupViewControllerDelegate {
    func didTapEdit() {
        guard let editClosure = editClosure, let cancelClosure = cancelClosure else {
            return
        }
        cancelClosure()
        let editVC = editClosure()
        self.dismiss(animated: false, completion: nil)
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    func didTapPractice() {
        guard let practiceClosure = practiceClosure, let cancelClosure = cancelClosure else {
            return
        }
        let practiceVC = practiceClosure()
        self.dismiss(animated: true, completion: cancelClosure)
        navigationController?.pushViewController(practiceVC, animated: true)
    }
    
    func didTapTest() {
        print("Tap Test")
    }
    
    func didTapDelete() {
        guard let deleteClosure = deleteClosure else {
            return
        }
        
        let alert = UIAlertController(title: "Delete?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            deleteClosure()
            self.dismiss(animated: true, completion: nil)
            self.tabBarController?.tabBar.isHidden = false
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func didTapExit() {
        guard let cancelClosure = cancelClosure else {
            return
        }
        self.dismiss(animated: true, completion: cancelClosure)
        tabBarController?.tabBar.isHidden = false
    }
}
