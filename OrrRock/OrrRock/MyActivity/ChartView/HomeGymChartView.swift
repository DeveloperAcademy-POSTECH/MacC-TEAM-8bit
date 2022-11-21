//
//  homeGymChartView.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/21.
//

import Charts
import SwiftUI

struct HomeGymChartView: View {
    let mostFrequentlyVisitedGymList: [(String, Int)]
    let totalGymVisitedDate: Int
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Label("홈짐", systemImage: "house")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(uiColor: UIColor.orrBlack!))
                
                Text("주로 방문하는 클라이밍장은 \n\(mostFrequentlyVisitedGymList[0].0)입니다.")
                    .lineLimit(2)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(uiColor: UIColor.orrBlack!))
                    .padding(.top, 8)
                
                VStack(alignment: .trailing){
                    Text("\(mostFrequentlyVisitedGymList[0].1)/\(totalGymVisitedDate)회 방문함")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(uiColor: UIColor.orrBlack!))
                        
                    Chart {
                        BarMark(x: .value(mostFrequentlyVisitedGymList[0].0, mostFrequentlyVisitedGymList[0].1))
                            .foregroundStyle(by: .value("color", mostFrequentlyVisitedGymList[0].0))
                        BarMark(x: .value(mostFrequentlyVisitedGymList[1].0, mostFrequentlyVisitedGymList[1].1))
                            .foregroundStyle(by: .value("color", mostFrequentlyVisitedGymList[1].0))
                        BarMark(x: .value(mostFrequentlyVisitedGymList[2].0, mostFrequentlyVisitedGymList[2].1))
                            .foregroundStyle(by: .value("color", mostFrequentlyVisitedGymList[2].0))
                        BarMark(x: .value("기타", totalGymVisitedDate - mostFrequentlyVisitedGymList[0].1 - mostFrequentlyVisitedGymList[1].1 - mostFrequentlyVisitedGymList[2].1))
                            .foregroundStyle(by: .value("color", "기타"))
                    }
                    
                    .chartXScale(domain: 0...totalGymVisitedDate)
//                    .chartXAxis(.hidden)
//                    .chartYAxis(.hidden)
                    .chartForegroundStyleScale([
                        mostFrequentlyVisitedGymList[0].0: Color(uiColor: UIColor(hex: "00A4FF")),
                        mostFrequentlyVisitedGymList[1].0: Color(uiColor: UIColor(hex: "55D3FF")),
                        mostFrequentlyVisitedGymList[2].0: Color(uiColor: UIColor(hex: "B4EBFF")),
                        "기타": Color(uiColor: UIColor(hex: "F4F4F4")),
                    ])
                    .frame(height: 60)
                }
            }
            .padding()
        }
        .frame(width: UIScreen.main.bounds.width - 32, height: 210)
        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.white))
    }
}
