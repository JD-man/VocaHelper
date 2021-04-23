//
//  WordsViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/23.
//

import UIKit

class WordsViewController: UIViewController {
    
    var collectionView:  UICollectionView?
    
    // test용 파일개수
    var lastIdx: Int = 10
    
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
        layout.itemSize = CGSize(width: view.bounds.width/3-10, height: view.bounds.width/3-10)
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
            cell.label.text = "Name"
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // Action Sheet이 아닌 Custom PopUp View를 만들어야 할듯
        if let cell = collectionView.cellForItem(at: indexPath) as? WordsCollectionViewCell {
            let actionSheet = UIAlertController(title: "Select" , message: "you want", preferredStyle: .alert)
            actionSheet.addTextField { (tf) in
                tf.returnKeyType = .default
                tf.placeholder = "Change Name"
                tf.textAlignment = .center
                tf.autocorrectionType = .no
                tf.clearButtonMode = .whileEditing
                tf.text = cell.label.text
            }
            actionSheet.addAction(UIAlertAction(title: "Edit", style: .destructive, handler: { (_) in
                print("\(cell.label.text!)")
            }))
            actionSheet.addAction(UIAlertAction(title: "Practice", style: .default, handler: nil))
            actionSheet.addAction(UIAlertAction(title: "Test", style: .default, handler: nil))
            actionSheet.addAction(UIAlertAction(title: "Exit", style: .cancel, handler: { (_) in
                cell.label.text = actionSheet.textFields?[0].text
            }))
            
            self.present(actionSheet, animated: true, completion: nil)
        } else {
            if let _ = collectionView.cellForItem(at: indexPath) as? AddCollectionViewCell {
                // Add Cell
                lastIdx += 1
                collectionView.reloadData()
                print("Add Cell")
            } else { return } }
    }
}
