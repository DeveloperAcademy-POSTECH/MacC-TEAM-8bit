//
//  GrowthChartView.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/21.
//

import Charts
import SwiftUI

struct GrowthChartView: View {
    @State private var selectedTimePeriod: TimePeriodEnum = .week
    var chartData: [[SolvedProblemsOfEachLevel]]
    let mostFrequentLevelForPeriod: [String]

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Label("성장", systemImage: "chart.bar.fill")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(uiColor: UIColor.orrBlack!))
                
                // 차트
                VStack(alignment: .leading){
                    Picker("피커", selection: $selectedTimePeriod) {
                        ForEach(TimePeriodEnum.allCases, id: \.self) { period in
                            Text("\(period.toString())").tag(period)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Text("지난 \(selectedTimePeriod.toString())동안 가장 많이 도전한 문제는\n\(mostFrequentLevelForPeriod[selectedTimePeriod.rawValue])입니다.")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color(uiColor: UIColor.orrBlack!))
                        .padding(.vertical, CGFloat(OrrPd.pd16.rawValue))
                    
                    Chart(chartData[selectedTimePeriod.rawValue]) { solvedProblemsOfEachLevel in
                        ForEach(solvedProblemsOfEachLevel.problems) { solvedProblemsOfEachPeriod in
                            BarMark(x: .value("name", solvedProblemsOfEachPeriod.periodName),
                                    y: .value("count", solvedProblemsOfEachPeriod.count))
                            .foregroundStyle(by: .value("name", solvedProblemsOfEachLevel.name))
                            .cornerRadius(4)
                        }
                    }
                    .chartXAxis {
                        AxisMarks(position: .bottom) { value in
                            AxisValueLabel(collisionResolution: .greedy(minimumSpacing: 10)) {
                                if let intValue = value.as(String.self) {
                                    Text(intValue)
                                        .font(.system(size: 10))
                                }
                            }
                        }
                    }
                    .chartForegroundStyleScale([
                        "v0": Color(uiColor: UIColor(hex: "00C7BE")),
                        "v1": Color(uiColor: UIColor(hex: "FF3B30")),
                        "v2": Color(uiColor: UIColor(hex: "FF9500")),
                        "v3": Color(uiColor: UIColor(hex: "FFCC00")),
                        "v4": Color(uiColor: UIColor(hex: "34C759")),
                        "v5": Color(uiColor: UIColor(hex: "007AFF")),
                        "v6": Color(uiColor: UIColor(hex: "5856D6")),
                        "v7": Color(uiColor: UIColor(hex: "AF52DE")),
                        "v8": Color(uiColor: UIColor(hex: "E5E5E5")),
                        "v9": Color(uiColor: UIColor(hex: "000000")),
                    ])
                    .chartLegend(.hidden)
                }
            }
            .padding()
        }
        .frame(width: UIScreen.main.bounds.width - 32, height: 450)
        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.white))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(uiColor: .orrGray200!), lineWidth: 1)
        )
    }
}

enum TimePeriodEnum: Int, CaseIterable {
    case week = 0
    case month = 1
    case year = 2
    
    func toString() -> String {
        switch self {
        case .week:
            return "1주"
        case .month:
            return "1개월"
        case .year:
            return "1년"
        }
    }
    
    func unitString() -> String {
        switch self {
        case .week:
            return "일"
        case .month:
            return "주"
        case .year:
            return "개월"
        }
    }
    
    func thisString() -> String {
        switch self {
        case .week:
            return "오늘"
        case .month:
            return "이번 주"
        case .year:
            return "이번 달"
        }
    }
}
