//
//  ResultTableViewHeader.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/07/03.
//

import UIKit
import Charts

class ResultTableViewHeader: UIView {
    
    let pieChartBackground: UIView = {
        let view = UIView()
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    let pieChartLabel: UILabel = {
        let label = UILabel()
        label.text = "시험결과"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pieChart: PieChartView = {
        let chart = PieChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    let lineChartBackground: UIView = {
        let view = UIView()
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    let lineChartLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 5개 시험결과"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lineChart: LineChartView = {
        let chart = LineChartView()
        chart.rightAxis.enabled = false
        chart.isUserInteractionEnabled = false
        chart.legend.enabled = false
        
        // x축설정
        let xAxis = chart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawLabelsEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        
        // y축 설정
        let yAxis = chart.leftAxis
        yAxis.drawGridLinesEnabled  = false
        yAxis.drawLabelsEnabled = false
        yAxis.drawAxisLineEnabled = false
        
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    let checkWrongAnswerLabel: UILabel = {
        let label = UILabel()
        label.text = "오답정리"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        constraintsConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
        
    private func addSubviews() {
        addSubview(pieChartBackground)
        addSubview(lineChartBackground)
        addSubview(pieChartLabel)
        addSubview(pieChart)
        addSubview(lineChartLabel)
        addSubview(lineChart)
        addSubview(checkWrongAnswerLabel)
    }
    
    private func constraintsConfigure() {
        pieChartBackground.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        pieChartBackground.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        pieChartBackground.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.42).isActive = true
        pieChartBackground.widthAnchor.constraint(equalTo: pieChartBackground.heightAnchor, multiplier: 1.05).isActive = true
        
        pieChartLabel.topAnchor.constraint(equalTo: pieChartBackground.topAnchor, constant: 10).isActive = true
        pieChartLabel.centerXAnchor.constraint(equalTo: pieChartBackground.centerXAnchor).isActive = true
        pieChartLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pieChartLabel.widthAnchor.constraint(equalTo: pieChartBackground.widthAnchor).isActive = true
        
        pieChart.topAnchor.constraint(equalTo: pieChartLabel.bottomAnchor).isActive = true
        pieChart.centerXAnchor.constraint(equalTo: pieChartBackground.centerXAnchor).isActive = true
        pieChart.widthAnchor.constraint(equalTo: pieChartBackground.widthAnchor).isActive = true
        pieChart.bottomAnchor.constraint(equalTo: pieChartBackground.bottomAnchor).isActive = true
        
        lineChartBackground.topAnchor.constraint(equalTo: pieChartBackground.bottomAnchor, constant: 25).isActive = true
        lineChartBackground.centerXAnchor.constraint(equalTo: pieChartBackground.centerXAnchor).isActive = true
        lineChartBackground.widthAnchor.constraint(equalTo: pieChartBackground.widthAnchor).isActive = true
        lineChartBackground.heightAnchor.constraint(equalTo: pieChartBackground.heightAnchor).isActive = true
        
        lineChartLabel.topAnchor.constraint(equalTo: lineChartBackground.topAnchor, constant: 10).isActive = true
        lineChartLabel.centerXAnchor.constraint(equalTo: pieChartBackground.centerXAnchor).isActive = true
        lineChartLabel.heightAnchor.constraint(equalTo: pieChartLabel.heightAnchor).isActive = true
        lineChartLabel.widthAnchor.constraint(equalTo: pieChartBackground.widthAnchor).isActive = true
        
        lineChart.topAnchor.constraint(equalTo: lineChartLabel.bottomAnchor).isActive = true
        lineChart.bottomAnchor.constraint(equalTo: lineChartBackground.bottomAnchor).isActive = true
        lineChart.centerXAnchor.constraint(equalTo: lineChartBackground.centerXAnchor).isActive = true
        lineChart.widthAnchor.constraint(equalTo: lineChartBackground.widthAnchor).isActive = true
        
        checkWrongAnswerLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        checkWrongAnswerLabel.topAnchor.constraint(equalTo: lineChartBackground.bottomAnchor).isActive = true
        checkWrongAnswerLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        checkWrongAnswerLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor).isActive = true
    }
}
