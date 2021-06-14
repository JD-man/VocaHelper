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
        return label
    }()
    
    private let prevButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "backward"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "forward"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let blind: BlindUIView = {
        let view = BlindUIView()
        view.clipsToBounds = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        rxConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let labelWidth = view.bounds.width / 2 - 15
        let labelHeight = labelWidth / 3
        
        let buttonSize: CGFloat = 25
        let blindPadding: CGFloat = 10
        
        wordLabel.frame = CGRect(
            x: view.bounds.origin.x + 10,
            y: view.bounds.height/2 - labelHeight/2,
            width: labelWidth,
            height: labelHeight
        )
        meaningLabel.frame = CGRect(
            x: view.bounds.width / 2 + 5,
            y: view.bounds.height/2 - labelHeight/2,
            width: labelWidth,
            height: labelHeight
        )
        prevButton.frame = CGRect(
            x: labelWidth / 2 + 10 - buttonSize/2,
            y: wordLabel.frame.origin.y + labelHeight + buttonSize * 1.5,
            width: buttonSize,
            height: buttonSize
        )
        nextButton.frame = CGRect(
            x: view.bounds.width - (labelWidth / 2 + 10) - buttonSize/2,
            y: wordLabel.frame.origin.y + labelHeight + buttonSize * 1.5,
            width: buttonSize,
            height: buttonSize
        )
        blind.frame = CGRect(
            x: view.bounds.width/2,
            y: meaningLabel.frame.origin.y - blindPadding/2,
            width: labelWidth + blindPadding,
            height: labelHeight + blindPadding
        )
    }
    
    private func addSubviews() {
        view.addSubview(wordLabel)
        view.addSubview(meaningLabel)
        view.addSubview(blind)
        view.addSubview(prevButton)
        view.addSubview(nextButton)
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward"))
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
        if index >= VocaManager.shared.vocasCount {
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
