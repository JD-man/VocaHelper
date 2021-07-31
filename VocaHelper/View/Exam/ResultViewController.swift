//
//  ResultViewController.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/04/29.
//

import UIKit
import RxSwift
import RxCocoa

class ResultViewController: UIViewController {
    
    deinit {
        print("resultVC deinit")
    }
    
    public weak var presentingView: ExamViewController?
    public var viewModel: VocaViewModel!
    private let disposeBag = DisposeBag()
    
    private let resultTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 70
        tableView.register(ResultTableViewCell.self, forCellReuseIdentifier: ResultTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(resultTableView)
        constraintsConfigure()
        //setHeaderFooter()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setHeaderFooter()
        rxConfigure()
    }
    
    private func constraintsConfigure() {
        resultTableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        resultTableView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        resultTableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        resultTableView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
    }
    
    private func setHeaderFooter() {
        let footer = ResultTableViewFooter(frame: CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: 70))
        let header = ResultTableViewHeader(frame: CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: view.safeAreaLayoutGuide.layoutFrame.height))
        resultTableView.tableFooterView = footer
        resultTableView.tableHeaderView = header
    }
    
    private func toRoot() {
        presentingView?.navigationController?.popToRootViewController(animated: true)
        presentingView?.tabBarController?.tabBar.isHidden = false
    }
    
    private func rxConfigure() {
        
        viewModel.makeResultCellSubject()
        
        viewModel.resultCellSubject
            .map({
                $0.filter { $0.score == "오답" }
            })
            .bind(to: resultTableView.rx.items(cellIdentifier: ResultTableViewCell.identifier,
                                               cellType: ResultTableViewCell.self)) { row, item, cell in
                cell.wordLabel.text = item.questionWord
                cell.userAnswerLabel.text = item.userAnswer + "\n 답: \(item.realAnswer)"
                cell.userAnswerLabel.textColor = .systemPink
            }.disposed(by: disposeBag)
        
        // Header 설정
        
        guard let header = resultTableView.tableHeaderView as? ResultTableViewHeader else {
            return
        }
        
        viewModel.resultCellSubject
            .map { cell -> [Int] in
                let wrongCount = cell.filter { resultCell in return resultCell.score == "오답" }.count
                let answerCount = cell.filter { resultCell in return resultCell.score == "정답" }.count
                let answerRate = (Double(answerCount) / Double((wrongCount + answerCount))) * 100
                return [answerCount, wrongCount, Int(answerRate)]
            }.subscribe(onNext: { [weak self] in
                self?.viewModel.setPieChart(datas: $0, chart: header.pieChart)
            })
            .disposed(by: disposeBag)
        
        viewModel.setLineChart(lineChart: header.lineChart)
        
                
        // Footer 설정
        guard let footer = resultTableView.tableFooterView as? ResultTableViewFooter else {
            return
        }
        
        footer.homeButton.rx.tap
            .bind() { [weak self] in                
                self?.dismiss(animated: true, completion: {
                    self?.presentingView?.tabBarController?.tabBar.isHidden.toggle()
                    self?.presentingView?.navigationController?.popToRootViewController(animated: true)
                })
            }.disposed(by: disposeBag)
        
        footer.examButton.rx.tap
            .bind() { [weak self] in                
                self?.dismiss(animated: true, completion: {self?.viewModel.buttonCountSubject.onNext(0)})
            }.disposed(by: disposeBag)
    }
}
