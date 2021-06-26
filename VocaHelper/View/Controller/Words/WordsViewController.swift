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
    
    public var viewModels = WordsViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfigure()
        rxConfigure()
        //print(VocaManager.directoryURL?.absoluteString)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
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
                    cell.didTap = { self?.viewModels.makeNewViewModels(isAddButton: true) }
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
