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
        //print(VocaManager.directoryURL?.absoluteString)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()        
    }
    
    override func viewWillAppear (_ animated: Bool) {
        navigationController?.navigationBar.sizeToFit()
        viewModels.makeNewViewModels(isAddButton: false)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.navigationController?.navigationBar.sizeToFit()
        }, completion: nil)
    }
    
    
    private func viewConfigure() {
        navigationItem.title = "단어장"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let layout = WordsCollectionViewFlowLayout(view: view)
        
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
                cell.fileNameTextField.text = item.changeToRealName(fileName: item.fileName)
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
