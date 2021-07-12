//
//  UploadModalViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/07/12.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class UploadModalViewController: UIViewController {
    
    public var viewModel: WebViewModel?
    public var disposeBag = DisposeBag()
    
    private var collectionView: UICollectionView?
    
    private let handleView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let handleImage: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let uploadButton: UIButton = {
        let button = UIButton()
        button.setTitle("업로드", for: .normal)
        button.backgroundColor = .systemTeal
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.backgroundColor = .systemPink
        return button
    }()
    
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
                        
        view.addSubview(handleView)
        view.addSubview(handleImage)
        view.addSubview(collectionView!)
        view.addSubview(uploadButton)
        view.addSubview(backButton)
    }
    
    private func rxConfigure() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.makewebModalSubject()
        
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<SectionOfWordsCell>  { [weak self] dataSource, cv, indexPath, item in
            guard let  cell = cv.dequeueReusableCell(withReuseIdentifier: WordsCollectionViewCell.identifier,
                                                     for: indexPath) as? WordsCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.label.text = item.fileName
            return cell
        }
        
        
        viewModel.webModalSubject
            .bind(to: collectionView!.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

    
