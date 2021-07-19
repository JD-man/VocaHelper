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
    
    private var collectionView: UICollectionView?
    
    public var viewModels = WordsViewModel()
    public var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        viewConfigure()        
        rxConfigure()
        print(VocaManager.directoryURL?.absoluteString)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()        
    }
    
    override func viewWillAppear (_ animated: Bool) {
        viewModels.makeNewViewModels(isAddButton: false)
    }
    
    private func viewConfigure() {
        navigationItem.title = "단어장"
        navigationController?.navigationBar.prefersLargeTitles = true
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = view.bounds.width < view.bounds.height ?
            CGSize(width: view.bounds.width/3-15, height: view.bounds.width/3-20) :
            CGSize(width: view.bounds.height/3-15, height: view.bounds.height/3-20)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.register(WordsCollectionViewCell.self, forCellWithReuseIdentifier: WordsCollectionViewCell.identifier)
        collectionView?.register(AddCollectionViewCell.self, forCellWithReuseIdentifier: AddCollectionViewCell.identifier)
        collectionView?.backgroundColor = .systemBackground
        
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView!)
        
        collectionView?.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        collectionView?.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        collectionView?.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        collectionView?.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
    }
    
    private func rxConfigure() {
        
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<SectionOfWordsCell>  { [weak self] dataSource, cv, indexPath, item in
            if item.fileName != "ButtonCell" {                
                guard let  cell = cv.dequeueReusableCell(withReuseIdentifier: WordsCollectionViewCell.identifier,
                                                         for: indexPath) as? WordsCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.label.text = item.changeToRealName(fileName: item.fileName)
                cell.didTap = {
                    item.didTapWordButton(view: self!)
                }
                return cell
            }
            else {
                guard let  cell = cv.dequeueReusableCell(withReuseIdentifier: AddCollectionViewCell.identifier,
                                                         for: indexPath) as? AddCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.didTap = { self?.viewModels.makeNewViewModels(isAddButton: true) }
                cell.backgroundColor = .clear
                return cell
            }
        }
        
        viewModels.fileNameSubject
            .bind(to: collectionView!.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
