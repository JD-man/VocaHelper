//
//  WordsViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class WordsViewController: UIViewController {
    
    private var collectionView:  UICollectionView?
    
    public var viewModels = WordsViewModelList()
    private let disposeBag = DisposeBag()
    
    // 파일개수
    private var fileNames: [String] = []
    private var fileCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfigure()
        rxConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        //fileLoad()
    }
    
    private func viewConfigure() {
        title = "Words"
        navigationController?.navigationBar.prefersLargeTitles = true
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
        
        
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(collectionView)
    }
    
    private func rxConfigure() {
        guard let collectionView = collectionView else {
            return
        }
        
        viewModels.fileNameSubject
            .bind(to: collectionView.rx.items) { [weak self] cv, row, item in
                if item.fileName == "ButtonCell" {
                    guard let  cell = cv.dequeueReusableCell(withReuseIdentifier: AddCollectionViewCell.identifier,
                                                             for: IndexPath(row:row, section: 0)) as? AddCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.didTap = { item.didTapAddButton() }
                    return cell
                }
                else {
                    guard let  cell = cv.dequeueReusableCell(withReuseIdentifier: WordsCollectionViewCell.identifier,
                                                             for: IndexPath(row:row, section: 0)) as? WordsCollectionViewCell,
                          let strongSelf = self else {
                              return UICollectionViewCell()
                          }
                    cell.label.text = item.changeToRealName(fileName: item.fileName)
                    cell.didTap = { item.didTapWordButton(view: strongSelf) }
                    return cell
                }
            }.disposed(by: disposeBag)
    }
}



//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            return
//        }
//
//        // 파일 터치시 실행되는 부분
//        if let cell = collectionView.cellForItem(at: indexPath) as? WordsCollectionViewCell {
//            UIView.animate(withDuration: 0.2) {
//                cell.backgroundColor = .systemGray5
//                cell.backgroundColor = .systemBackground
//            }
//
//            // 커스텀 팝업뷰를 만들었음
//            let popupVC = PopupViewController()
//            popupVC.delegate = self
//            popupVC.modalPresentationStyle = .overCurrentContext
//            popupVC.textField.text = cell.label.text
//
//
//            // 팝업뷰의 버튼을 누르면 실행되야하는 클로저들을 여기에서 만들었다.
//            // 파일 셀을 터치하면 전부 생성됨
//
//            // edit 터치시 실행될 클로져
//            // 파일에 들어있는 단어들을 가지는 EditViewController을 생성해서 return한다.
//            editClosure = { [weak self] () -> EditViewController in
//                let editVC = EditViewController()
//
//                // 저장파일을 가져와야함
//                let decoder = JSONDecoder()
//                let path = directory.appendingPathComponent(self?.fileNames[indexPath.row] ?? "")
//                do {
//                        let data = try Data(contentsOf: path)
//                        editVC.voca = try decoder.decode(VocaData.self, from: data)
//                    } catch {
//                    print(error)
//                }
//                editVC.navigationItem.title = popupVC.textField.text
//                editVC.fileName = self?.fileNames[indexPath.row] ?? ""
//                return editVC
//            }
//
//            // practice 터치시 실행될 클로져
//
//            practiceClosure = { [weak self] ()->  PracticeViewController in
//                let practiceVC = PracticeViewController()
//
//                // 저장파일을 가져오기
//                let decoder = JSONDecoder()
//                let path = directory.appendingPathComponent(self?.fileNames[indexPath.row] ?? "")
//                do {
//                        let data = try Data(contentsOf: path)
//                    practiceVC.voca = try decoder.decode(VocaData.self, from: data)
//                    } catch {
//                    print(error)
//                }
//                practiceVC.navigationItem.title = popupVC.textField.text
//                return practiceVC
//            }
//
//            // test 터치시 실행될 클로져
//
//            testClosure = { [weak self]() -> TestViewController in
//                let testVC = TestViewController()
//                let decoder = JSONDecoder()
//                let path = directory.appendingPathComponent(self?.fileNames[indexPath.row] ?? "")
//                do {
//                        let data = try Data(contentsOf: path)
//                    testVC.voca = try decoder.decode(VocaData.self, from: data)
//                    } catch {
//                    print(error)
//                }
//                testVC.navigationItem.title = popupVC.textField.text
//                return testVC
//            }
//
//            // delete 터치시 실행될 클로져
//            deleteClosure = { [weak self] () -> Void in
//                self?.fileCount -= 1
//                collectionView.deleteItems(at: [indexPath])
//                let path = directory.appendingPathComponent(self?.fileNames[indexPath.row] ?? "")
//                self?.fileNames.remove(at: indexPath.row)
//                if let error = try? FileManager.default.removeItem(atPath: path.path) {
//                    print(error)
//                } else {
//                    return
//                }
//                return
//            }
//
//            // exit 터치시 실행될 클로져
//            cancelClosure = { [weak self] () -> Void in
//                guard let fileName = popupVC.textField.text else {
//                    return
//                }
//                //change file name
//                let realName = self?.fileNames[indexPath.row] ?? ""
//                let datePart = String(realName[realName.startIndex ..< realName.index(realName.startIndex, offsetBy: 25)])
//                let currRealName = datePart + fileName
//
//                let prevName = directory.appendingPathComponent(self?.fileNames[indexPath.row] ?? "").path
//                let currName = directory.appendingPathComponent(currRealName).path
//
//                do {
//                    try FileManager.default.moveItem(atPath: prevName, toPath: currName)
//                } catch {
//                    print(error)
//                }
//
//                cell.label.text = fileName
//                self?.fileNames[indexPath.row] = currRealName
//                //print(self.fileNames)
//                collectionView.reloadData()
//                return
//            }
//
//            tabBarController?.tabBar.isHidden = true
//            self.present(popupVC, animated: true, completion: nil)
//            }
//
//            // 추가하기 셀 터치하는 부분
//            else {
//            if let cell = collectionView.cellForItem(at: indexPath) as? AddCollectionViewCell {
//
//                UIView.animate(withDuration: 0.2) {
//                    cell.backgroundColor = .systemGray6
//                    cell.backgroundColor = .systemBackground
//                }
//                fileNames.append("\(Date())Name")
//                fileCount = fileNames.count
//                // 빈 파일 하나 추가
//                let newVocaData = VocaData(vocas: [Int : [String : String]]())
//                let encoder = JSONEncoder()
//                encoder.outputFormatting = .prettyPrinted
//                do {
//                    //print(directory)
//                    let path = directory.appendingPathComponent("\(Date())Name")
//                    let data = try encoder.encode(newVocaData)
//                    try data.write(to: path)
//                    } catch {
//                    print(error)
//                }
//
//                // 컬렉션뷰에 셀추가
//                collectionView.insertItems(at: [indexPath])
//                collectionView.reloadData()
//            } else { return } }
//    }
//}

//extension WordsViewController: PopupViewControllerDelegate {
//    func didTapEdit() {
//        guard let editClosure = editClosure, let cancelClosure = cancelClosure else {
//            return
//        }
//        cancelClosure()
//        let editVC = editClosure()
//        self.dismiss(animated: false, completion: nil)
//        navigationController?.pushViewController(editVC, animated: true)
//    }
//    
//    func didTapPractice() {
//        guard let practiceClosure = practiceClosure, let cancelClosure = cancelClosure else {
//            return
//        }
//        let practiceVC = practiceClosure()
//        self.dismiss(animated: true, completion: cancelClosure)
//        navigationController?.pushViewController(practiceVC, animated: true)
//    }
//    
//    func didTapTest() {
//        guard let testClosure = testClosure, let cancelClosure = cancelClosure else {
//            return
//        }
//        cancelClosure()
//        let testVC = testClosure()
//        // 저장된 단어들의 수가 10개 이상이어야 테스트 가능
//        let minimumCount: Int = 10        
//        if testVC.voca.vocas.count < minimumCount {            
//            let alert = UIAlertController(title: "테스트할 단어가 부족합니다.", message: "단어는 최소 \(minimumCount)개가 필요합니다.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        } else {
//            self.dismiss(animated: true, completion: nil)
//            navigationController?.pushViewController(testVC, animated: true)
//        }
//    }
//    
//    func didTapDelete() {
//        guard let deleteClosure = deleteClosure else {
//            return
//        }
//        
//        let alert = UIAlertController(title: "Delete?", message: "", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
//            deleteClosure()
//            self.collectionView?.reloadData()
//            self.dismiss(animated: true, completion: nil)
//            self.tabBarController?.tabBar.isHidden = false
//        }))
//        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//    
//    func didTapExit() {
//        guard let cancelClosure = cancelClosure else {
//            return
//        }
//        self.dismiss(animated: true, completion: cancelClosure)
//        tabBarController?.tabBar.isHidden = false
//    }
//}
