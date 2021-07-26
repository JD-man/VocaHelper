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
    
    private var index = 0
    
    private let wordLabel: UILabel = {
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
    
    private let meaningLabel: UILabel = {
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
    
    private let prevButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "backward"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "forward"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let blind: BlindUIView = {
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
                self?.nextMoveFrame()
            }.disposed(by: disposeBag)
        
        prevButton.rx.tap
            .bind() { [weak self] in
                self?.prevMoveFrame()
            }.disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind() { [weak self] in
                self?.tabBarController?.tabBar.isHidden.toggle()
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
    }
    
    private func nextMoveFrame() {
        index += 1
        if index >= VocaManager.shared.vocas.count {
            index -= 1
            let alert = UIAlertController(title: "마지막 단어입니다.", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let originLayerFrame = wordLabel.layer.frame.origin.x
        wordLabel.layer.frame.origin.x = -wordLabel.bounds.width - 5
        viewModel.buttonCountSubject.onNext(index)
        UIView.animate(withDuration: 0.7) { [weak self] in
            self?.wordLabel.frame.origin.x = originLayerFrame
        }
    }
    
    private func prevMoveFrame() {
        index -= 1
        if index <= -1{
            index += 1
            let alert = UIAlertController(title: "첫번째 단어입니다.", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let originLayerFrame = wordLabel.layer.frame.origin.x
        self.wordLabel.layer.frame.origin.x = meaningLabel.frame.origin.x
        viewModel.buttonCountSubject.onNext(index)
        UIView.animate(withDuration: 0.7) { [weak self] in
            self?.wordLabel.frame.origin.x = originLayerFrame
        }
    }
}
