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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let handleView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let handleArea: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.backgroundColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let handleImage: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let panGesture = UIPanGestureRecognizer()
    private let tapGesture = UITapGestureRecognizer()
    
    public var minHeight: CGFloat = 0
    public var maxHeight: CGFloat = 0
    
    public var handleViewHeightConstraint = NSLayoutConstraint()
    public var startY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfigure()
        constraintConfigure()
        rxConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.handleAnimation(height: minHeight, view: self)
    }
    
    private func viewConfigure() {
        // CollectionView Layout Config
        let layout = WordsCollectionViewFlowLayout(view: view)
        
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
        view.addSubview(blockView)
        view.addSubview(handleView)
        
        //Animate View when viewDidAppear
        minHeight = view.bounds.height * 0.3
        maxHeight = view.bounds.height * 0.7
    }
    
    private func constraintConfigure() {
        let handleAreaHeight: CGFloat = 30
        
        blockView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blockView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        blockView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        blockView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        handleView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        handleView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        handleView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        handleViewHeightConstraint = handleView.heightAnchor.constraint(
            equalTo: view.heightAnchor,
            multiplier: 0,
            constant: 0
        )
        handleViewHeightConstraint.isActive = true        
        
        handleArea.topAnchor.constraint(equalTo: handleView.topAnchor).isActive = true
        handleArea.leftAnchor.constraint(equalTo: handleView.leftAnchor).isActive = true
        handleArea.rightAnchor.constraint(equalTo: handleView.rightAnchor).isActive = true
        handleArea.heightAnchor.constraint(equalToConstant: handleAreaHeight).isActive = true
        
        handleImage.centerXAnchor.constraint(equalTo: handleArea.centerXAnchor).isActive = true
        handleImage.centerYAnchor.constraint(equalTo: handleArea.centerYAnchor).isActive = true
        handleImage.widthAnchor.constraint(equalToConstant: 30).isActive  = true
        handleImage.heightAnchor.constraint(equalToConstant: 5).isActive  = true
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.topAnchor.constraint(lessThanOrEqualTo: handleArea.bottomAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView?.leftAnchor.constraint(equalTo: handleView.leftAnchor).isActive = true
        collectionView?.rightAnchor.constraint(equalTo: handleView.rightAnchor).isActive = true
    }
    
    private func rxConfigure() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.makeWebModalSubject()
        
        tapGesture.rx.event
            .bind { [weak self] _ in
                self?.viewModel?.handleAnimation(height: 0.0, view: self!)
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
            cell.fileNameTextField.text = item.fileName
            cell.backGroundButton.isUserInteractionEnabled = false
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

    
