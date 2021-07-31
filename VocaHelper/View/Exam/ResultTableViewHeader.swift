//
//  ResultTableViewHeader.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/07/03.
//

import UIKit
import Charts

class ResultTableViewHeader: UIView {
    
    let pieChartLabel: UILabel = {
        let label = UILabel()
        label.text = "시험결과"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pieChart: PieChartView = {
        let chart = PieChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    let lineChartLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 5개 시험결과"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
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
        addSubview(pieChartLabel)
        addSubview(pieChart)
        addSubview(lineChartLabel)
        addSubview(lineChart)
        addSubview(checkWrongAnswerLabel)
    }
    
    private func constraintsConfigure() {
        pieChartLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        pieChartLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        pieChartLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.05).isActive = true
        pieChartLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        pieChartLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        
        pieChart.topAnchor.constraint(equalTo: pieChartLabel.bottomAnchor).isActive = true
        pieChart.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        pieChart.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor).isActive = true
        pieChart.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor).isActive = true
        
        lineChartLabel.topAnchor.constraint(equalTo: pieChart.bottomAnchor).isActive = true
        lineChartLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        lineChartLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.05).isActive = true
        lineChartLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        lineChartLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        
        checkWrongAnswerLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        checkWrongAnswerLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.05).isActive = true
        checkWrongAnswerLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        checkWrongAnswerLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor).isActive = true
        
        lineChart.topAnchor.constraint(equalTo: lineChartLabel.bottomAnchor).isActive = true
        lineChart.bottomAnchor.constraint(equalTo: checkWrongAnswerLabel.topAnchor).isActive = true
        lineChart.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        lineChart.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.95).isActive = true
    }
}
