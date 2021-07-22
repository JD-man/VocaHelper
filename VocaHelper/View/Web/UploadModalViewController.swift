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
    deinit {
        print("uploadmodal deinit")
    }
    
    public var viewModel: WebViewModel?
    public var disposeBag = DisposeBag()
    public var presenting: WebViewController?
    
    public var collectionView: UICollectionView?
    
    private let blockView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.3)
        return view
    }()
    
    public let handleView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 30
        view.backgroundColor = .systemBackground
        return view
    }()
    
    public let handleArea: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.backgroundColor = .darkGray
        return view
    }()
    
    private let handleImage: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 3
        return view
    }()
    
    public let bottomBlockView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let panGesture = UIPanGestureRecognizer()
    private let tapGesture = UITapGestureRecognizer()
    
    public var minHeight: CGFloat = 0
    public var maxHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfigure()
        rxConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bottomBlockHeight: CGFloat = view.safeAreaInsets.bottom
        let handleViewWidth: CGFloat = view.safeAreaLayoutGuide.layoutFrame.width
        
        blockView.frame = view.bounds
        handleView.frame = CGRect(x: 0.5 * (view.bounds.width - handleViewWidth) , y: view.bounds.height, width: handleViewWidth, height: view.bounds.height)
        handleArea.frame = CGRect(x: handleView.bounds.minX, y: handleView.bounds.minY, width: handleView.frame.width, height: 25)
        handleImage.frame = CGRect(x: 0.5 * (handleView.bounds.width - 30), y: 10 , width: 30, height: 5)
        
        collectionView?.frame = CGRect(x: 0, y: handleImage.frame.maxY + 10, width: handleView.frame.width, height: handleView.frame.height - minHeight - 25 - bottomBlockHeight)
        bottomBlockView.frame = CGRect(x: 0, y: collectionView?.frame.maxY ?? 0 + bottomBlockHeight, width: handleView.frame.width, height: bottomBlockHeight)
        
        //Animate View when viewDidLoad
        minHeight = view.bounds.height * 0.7
        maxHeight = view.bounds.height * 0.3
        viewModel?.handleAnimation(height: minHeight, view: self)
    }
    
    private func viewConfigure() {
        // CollectionView Layout Config
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = view.bounds.width < view.bounds.height ?
            CGSize(width: view.bounds.width/3-15, height: view.bounds.width/3-20) :
            CGSize(width: view.bounds.height/3-15, height: view.bounds.height/3-20)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        // CollectionView Config
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(WordsCollectionViewCell.self, forCellWithReuseIdentifier: WordsCollectionViewCell.identifier)
        collectionView?.backgroundColor = .systemBackground
        
        // Add Gestures
        blockView.addGestureRecognizer(tapGesture)
        handleArea.addGestureRecognizer(panGesture)
        
        // Add Subviews
        handleView.addSubview(handleArea)
        handleView.addSubview(handleImage)
        handleView.addSubview(collectionView!)
        handleView.addSubview(bottomBlockView)
        view.addSubview(blockView)
        view.addSubview(handleView)
        
    }
    
    private func rxConfigure() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.makeWebModalSubject()
        
        tapGesture.rx.event
            .bind { [weak self] _ in
                self?.viewModel?.handleAnimation(height: self?.handleView.frame.height ?? 0, view: self!)
            }.disposed(by: disposeBag)
        
        panGesture.rx.event
            .bind { [weak self] in
                self?.viewModel?.grabHandle(recognizer: $0, view: self!)
            }.disposed(by: disposeBag)
        
        
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<SectionOfWordsCell>  { dataSource, cv, indexPath, item in
            guard let  cell = cv.dequeueReusableCell(withReuseIdentifier: WordsCollectionViewCell.identifier,
                                                     for: indexPath) as? WordsCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.label.text = item.fileName
            cell.button.isUserInteractionEnabled = false
            return cell
        }
        
        viewModel.uploadModalSubject
            .bind(to: collectionView!.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView!.rx.itemSelected
            .bind { [weak self] indexPath in
                self?.viewModel?.uploadVocas(fileIndex: indexPath.row, view: self!)
            }.disposed(by: disposeBag)
    }
}

    
