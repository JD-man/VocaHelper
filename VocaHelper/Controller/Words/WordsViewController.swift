//
//  WordsViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/23.
//

import UIKit

class WordsViewController: UIViewController {
    
    private var collectionView:  UICollectionView?
    
    // test용 파일개수
    private var lastIdx: Int = 10
    
    // MARK: - Popup Closure
    
    private var deleteClosure: (() -> Void)?
    private var cancelClosure: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
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
        collectionView?.backgroundColor = .systemPink
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(collectionView)
    }
}

extension WordsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lastIdx + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == lastIdx {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCollectionViewCell.identifier, for: indexPath) as! AddCollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordsCollectionViewCell.identifier, for: indexPath) as! WordsCollectionViewCell
            cell.label.text = "\(indexPath.row)"
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // Action Sheet이 아닌 Custom PopUp View를 만들었음
        
        if let cell = collectionView.cellForItem(at: indexPath) as? WordsCollectionViewCell {
            let popupVC = PopupViewController()
            popupVC.delegate = self
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.textField.text = cell.label.text
            deleteClosure = { () -> Void in return collectionView.deleteItems(at: [IndexPath.init(row: indexPath.row, section: indexPath.section)])}
            cancelClosure = { () -> Void in return cell.label.text = popupVC.textField.text }
            self.present(popupVC, animated: true, completion: nil)
            } else {
            if let _ = collectionView.cellForItem(at: indexPath) as? AddCollectionViewCell {
                // Add Cell
                lastIdx += 1
                collectionView.insertItems(at: [IndexPath.init(row: indexPath.row, section: indexPath.section)])
                collectionView.reloadData()
                print("Add Cell")
            } else { return } }
    }
    
    
}

extension WordsViewController: PopupViewControllerDelegate {
    
    
    func didTapEdit() {
    }
    
    func didTapPractice() {
        print("Tap Practice")
    }
    
    func didTapTest() {
        print("Tap Test")
    }
    
    func didTapDelete() {
        guard let deleteClosure = deleteClosure, let collectionView = collectionView else {
            return
        }
        lastIdx -= 1
        deleteClosure()
        collectionView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func didTapExit() {
        guard let cancelClosure = cancelClosure else {
            return
        }
        self.dismiss(animated: true, completion: cancelClosure)
    }
}


