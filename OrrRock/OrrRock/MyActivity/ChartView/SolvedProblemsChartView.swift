//
//  SolvedChartView.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/19.
//

import Charts
import SwiftUI

struct SolvedProblemsChartView: View {
    @State private var selectedTimePeriod: TimePeriodEnum = .week
    var chartData: [[SolvedProblemsOfEachLevel]]
    
    var body: some View {
        ZStack {
            VStack{
                Picker("피커", selection: $selectedTimePeriod) {
                    ForEach(TimePeriodEnum.allCases, id: \.self) { period in
                        Text("\(period.toString())").tag(period)
                    }
                }
                .pickerStyle(.segmented)
                
                Spacer()
                
                Chart(chartData[selectedTimePeriod.rawValue]) { solvedProblemsOfEachLevel in
                    ForEach(solvedProblemsOfEachLevel.problems) { solvedProblemsOfEachPeriod in
                        BarMark(x: .value("name", solvedProblemsOfEachPeriod.periodName),
                                y: .value("count", solvedProblemsOfEachPeriod.count))
                        .foregroundStyle(by: .value("name", solvedProblemsOfEachLevel.name))
                    }
                }
                .frame(height: 220)
                .chartForegroundStyleScale([
                    "v0": Color(uiColor: .lightGray),
                    "v1": .yellow,
                    "v2": .orange,
                    "v3": .green,
                    "v4": .blue,
                    "v5": .red,
                    "v6": .purple,
                    "v7": Color(uiColor: .darkGray),
                    "v8": .brown,
                    "v9": .black,
                ])
            }
            .padding()
        }
        .frame(width: UIScreen.main.bounds.width - 32, height: 300)
        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.white))
    }
}

enum TimePeriodEnum: Int, CaseIterable {
    case week = 0
    case month = 1
    case year = 2
    
    func toString() -> String {
        switch self {
        case .week:
            return "주"
        case .month:
            return "월"
        case .year:
            return "년"
        }
    }
}
