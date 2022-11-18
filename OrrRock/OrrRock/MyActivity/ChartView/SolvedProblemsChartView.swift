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
    
    var body: some View {
        ZStack {
            VStack{
                Picker("피커", selection: $selectedTimePeriod) {
                    ForEach(TimePeriodEnum.allCases, id: \.self) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(.segmented)
                
                Spacer()
                
                Chart(totalSolvedProblems) { solvedProblemsOfEachLevel in
                    ForEach(solvedProblemsOfEachLevel.problems) { solvedProblemsOfEachPeriod in
                        BarMark(x: .value("name", solvedProblemsOfEachPeriod.weekday),
                                y: .value("count", solvedProblemsOfEachPeriod.count))
                        .foregroundStyle(by: .value("name", solvedProblemsOfEachLevel.name))
                    }
                }
                .frame(height: 220)
                .chartForegroundStyleScale([
                    "v1": .yellow,
                    "v2": .orange,
                ])
            }
            .padding()
        }
        .frame(width: UIScreen.main.bounds.width - 32, height: 300)
        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.white))
    }
}

enum TimePeriodEnum: String, CaseIterable {
    case week
    case month
    case entire
}

struct SolvedProblemsChartView_Previews: PreviewProvider {
    static var previews: some View {
        SolvedProblemsChartView()
    }
}

struct SolvedProblemsOfEachPeriod: Identifiable {
    let weekday: String
    let count: Int
    
    var id: String { weekday }
}

let v1: [SolvedProblemsOfEachPeriod] = [
    .init(weekday: "SUN", count: 123),
    .init(weekday: "MON", count: 234),
    .init(weekday: "TUE", count: 345),
    .init(weekday: "WED", count: 456),
    .init(weekday: "THU", count: 247),
    .init(weekday: "FRI", count: 543),
    .init(weekday: "SAT", count: 163),
]

let v2: [SolvedProblemsOfEachPeriod] = [
    .init(weekday: "SUN", count: 432),
    .init(weekday: "MON", count: 466),
    .init(weekday: "TUE", count: 732),
    .init(weekday: "WED", count: 126),
    .init(weekday: "THU", count: 442),
    .init(weekday: "FRI", count: 247),
    .init(weekday: "SAT", count: 111),
]

struct SolvedProblemsOfEachLevel: Identifiable {
    var id: String {
        name
    }
    
    let name: String
    let problems: [SolvedProblemsOfEachPeriod]
}

let totalSolvedProblems: [SolvedProblemsOfEachLevel] = [
    .init(name: "v1", problems: v1),
    .init(name: "v2", problems: v2)
]
