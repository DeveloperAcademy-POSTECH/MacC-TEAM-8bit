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
                Label("홈짐", systemImage: "house.fill")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(uiColor: UIColor.orrBlack!))

                if isChartDataEmpty() {
                    Text("데이터 없음")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color(uiColor: UIColor.orrBlack!))
                        .padding(.top, CGFloat(OrrPd.pd8.rawValue))
                    
                    Text("기록을 추가하면 홈짐이 자동으로 작성됩니다")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(uiColor: UIColor.orrGray500!))
                    
                    VStack(alignment: .trailing) {
                        Text("-/-회 방문함")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color(uiColor: UIColor.orrBlack!))
                        
                        RoundedRectangle(cornerRadius: 4)
                            .frame(height: 20)
                            .foregroundColor(Color(uiColor: UIColor.orrGray100!))
                    }
                    .padding(.bottom, CGFloat(OrrPd.pd16.rawValue))
                    
                } else {
                    Text("주로 방문하는 클라이밍장은 \n\(mostFrequentlyVisitedGymList[0].0)입니다.")
                        .lineLimit(2)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color(uiColor: UIColor.orrBlack!))
                        .frame(height: 50)
                    
                    Spacer()
                    
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
                        .chartForegroundStyleScale(
                            createColorSetForChart()
                        )
                        .frame(height: 60)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width - CGFloat(OrrPd.pd16.rawValue) * 4, height: isChartDataEmpty() ? 136 : 188, alignment: .topLeading)
        }
        .frame(width: UIScreen.main.bounds.width - CGFloat(OrrPd.pd16.rawValue) * 2, height: isChartDataEmpty() ? 168 : 220)
        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.white))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(uiColor: .orrGray200!), lineWidth: 1)
        )
    }
    
    func createColorSetForChart() -> KeyValuePairs<String, Color> {
        // KeyValuePairs는 append가 불가능해, 케이스를 나누어 작업해야 합니다.
        if mostFrequentlyVisitedGymList[0].0 == "" {
            return [:]
        } else if mostFrequentlyVisitedGymList[1].0 == "" {
            return [
                mostFrequentlyVisitedGymList[0].0: Color(uiColor: UIColor(hex: "00A4FF")),
            ]
        } else if mostFrequentlyVisitedGymList[2].0 == "" {
            return [
                mostFrequentlyVisitedGymList[0].0: Color(uiColor: UIColor(hex: "00A4FF")),
                mostFrequentlyVisitedGymList[1].0: Color(uiColor: UIColor(hex: "55D3FF")),
            ]
        } else {
            return [
                mostFrequentlyVisitedGymList[0].0: Color(uiColor: UIColor(hex: "00A4FF")),
                mostFrequentlyVisitedGymList[1].0: Color(uiColor: UIColor(hex: "55D3FF")),
                mostFrequentlyVisitedGymList[2].0: Color(uiColor: UIColor(hex: "B4EBFF")),
                "기타": Color(uiColor: UIColor(hex: "F4F4F4")),
            ]
        }
    }
    
    func isChartDataEmpty() -> Bool {
        return mostFrequentlyVisitedGymList[0].1 == 0
    }
}
