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
            
        }
        .frame(width: UIScreen.main.bounds.width - 32, height: 300)
        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.white))
    }
}

