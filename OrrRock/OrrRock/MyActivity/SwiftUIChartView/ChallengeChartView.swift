//
//  ChallengeChartView.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/19.
//  https://tutorial101.blogspot.com/2021/08/swiftui-pie-chart.html

import Charts
import SwiftUI

struct ChallengeChartView: View {
    let chartData: ChartDataModel
    let totalCount: Int
    let successCount: Int
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Label("모든 도전", systemImage: "wallet.pass.fill")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(uiColor: UIColor.orrBlack!))
                
                // 차트
                ZStack{
                    HStack {
                        Text("\(0)")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color(uiColor: UIColor.orrGray400!))
                        Spacer()
                        Text("\(totalCount)")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color(uiColor: UIColor.orrGray400!))
                    }
                    .padding(.horizontal, 4)
                    .frame(height: 28, alignment: .bottom)
                    .overlay(Rectangle().frame(width: 1, height: nil, alignment: .leading).foregroundColor(Color(uiColor: UIColor.orrGray400!)), alignment: .leading)
                    .overlay(Rectangle().frame(width: 1, height: nil, alignment: .trailing).foregroundColor(Color(uiColor: UIColor.orrGray400!)), alignment: .trailing)

                    ZStack(alignment: .top){
                        HStack(spacing: (UIScreen.main.bounds.width - CGFloat(OrrPd.pd16.rawValue) * 4 - 100) / 100) {
                            ForEach(0..<100) { index in
                                Rectangle().frame(width: 1, height: (index % 10 == 0) ? 10 : 3)
                                    .border(Color(uiColor: UIColor.orrGray200!))
                                    .padding(0)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - CGFloat(OrrPd.pd16.rawValue) * 4, height: 10)
                        
                        Chart {
                            BarMark(x: .value("name", successCount))
                                .cornerRadius(10)
                        }
                        .frame(height: 28)
                        .chartXScale(domain: 0...totalCount)
                        .chartXAxis {
                            AxisMarks(position: .bottom) { value in
                                AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 3]))
                                AxisValueLabel() {
                                    if let intValue = value.as(Int.self) {
                                        Text("")
                                            .font(.system(size: 10))
                                    }
                                }
                            }
                        }
                        .chartYAxis(.hidden)
                    }
                }
                
                HStack() {
                    if totalCount == 0 {
                        Text("기록을 추가하면 도전 그래프가 자동으로 작성됩니다")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color(uiColor: UIColor.orrGray500!))
                        Spacer()
                    } else {
                        Text("\(successCount)번의 성공")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(Color(uiColor: UIColor.orrGray700!))
                        Spacer()
                        
                        Text("\(totalCount)번의 도전")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(Color(uiColor: UIColor.orrGray700!))
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width - CGFloat(OrrPd.pd16.rawValue) * 4, height: 98, alignment: .topLeading)
        }
        .frame(width: UIScreen.main.bounds.width - CGFloat(OrrPd.pd16.rawValue) * 2, height: 130)
        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.white))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(uiColor: .orrGray200!), lineWidth: 1)
        )
    }
}

struct ChartCellModel: Identifiable {
    let id = UUID()
    
    var numOfSolvedProblems: CGFloat
    let level: String
}

final class ChartDataModel: ObservableObject {
    var chartCellModel: [ChartCellModel]
    
    init(dataModel: [ChartCellModel]) {
        chartCellModel = dataModel
    }
    
    var totalNumberOfSolvedProblems: CGFloat {
        chartCellModel.reduce(CGFloat(0)) { (result, data) -> CGFloat in
            result + data.numOfSolvedProblems
        }
    }
}
