//
//  PracticeViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/28.
//

import UIKit
import RxSwift
import RxCocoa

class PracticeViewController: UIViewController {
    deinit {
        print("practice deinit")
    }
    
    public var fileName: String = ""
    
    private lazy var viewModel = VocaViewModel(fileName: fileName)
    private let disposeBag = DisposeBag()
    
    public var index = 0
    
    public let wordLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .label
        label.textAlignment = .center
        label.textColor = .systemBackground
        label.text = "word"
        label.font = UIFont.systemFont(ofSize: 25)
        label.adjustsFontSizeToFitWidth = true
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let meaningLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .label
        label.textAlignment = .center
        label.textColor = .systemBackground
        label.text = "meaning"
        label.font = UIFont.systemFont(ofSize: 25)
        label.adjustsFontSizeToFitWidth = true
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let prevButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: "backward"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: "forward"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public let blind: BlindUIView = {
        let view = BlindUIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        constraintsConfigure()
        rxConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if size.width > size.height {
            wordLabel.font = UIFont.systemFont(ofSize: 50)
            meaningLabel.font = UIFont.systemFont(ofSize: 50)
        }
        else {
            wordLabel.font = UIFont.systemFont(ofSize: 25)
            meaningLabel.font = UIFont.systemFont(ofSize: 25)
        }
    }
    
    private func addSubviews() {
        view.addSubview(wordLabel)
        view.addSubview(meaningLabel)
        view.addSubview(prevButton)
        view.addSubview(nextButton)
        view.addSubview(blind)
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward"))
    }
    
    private func constraintsConfigure() {
        
        wordLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        wordLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -10).isActive = true
        wordLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        wordLabel.heightAnchor.constraint(equalTo: wordLabel.widthAnchor, multiplier: 0.3).isActive = true
        
        meaningLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 10).isActive = true
        meaningLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        meaningLabel.centerYAnchor.constraint(equalTo: wordLabel.centerYAnchor).isActive = true
        meaningLabel.heightAnchor.constraint(equalTo: wordLabel.heightAnchor).isActive = true

        prevButton.centerXAnchor.constraint(equalTo: wordLabel.centerXAnchor).isActive = true
        prevButton.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 15).isActive = true
        prevButton.widthAnchor.constraint(equalTo: wordLabel.widthAnchor, multiplier: 0.15).isActive = true
        prevButton.heightAnchor.constraint(equalTo: wordLabel.widthAnchor, multiplier: 0.15).isActive = true

        nextButton.centerXAnchor.constraint(equalTo: meaningLabel.centerXAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo: meaningLabel.bottomAnchor, constant: 15).isActive = true
        nextButton.widthAnchor.constraint(equalTo: prevButton.widthAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalTo: prevButton.heightAnchor).isActive = true

        blind.centerXAnchor.constraint(equalTo: meaningLabel.centerXAnchor).isActive = true
        blind.centerYAnchor.constraint(equalTo: meaningLabel.centerYAnchor).isActive = true
        blind.widthAnchor.constraint(equalTo: meaningLabel.widthAnchor, constant: 10).isActive = true
        blind.heightAnchor.constraint(equalTo: meaningLabel.heightAnchor, constant: 10).isActive = true
        
        if view.bounds.width > view.bounds.height {
            wordLabel.font = UIFont.systemFont(ofSize: 50)
            meaningLabel.font = UIFont.systemFont(ofSize: 50)
        }
    }
    
    private func rxConfigure() {
        viewModel.buttonCountSubject
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.practiceCellObservable
            .subscribe(onNext: { [weak self] in
                self?.wordLabel.text = $0.word
                self?.meaningLabel.text = $0.meaning
            }).disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind() { [weak self] in
                self?.viewModel.nextMoveFrame(view: self!)
            }.disposed(by: disposeBag)
        
        prevButton.rx.tap
            .bind() { [weak self] in
                self?.viewModel.prevMoveFrame(view: self!)                
            }.disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind() { [weak self] in
                self?.tabBarController?.tabBar.isHidden.toggle()
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
    }
}
