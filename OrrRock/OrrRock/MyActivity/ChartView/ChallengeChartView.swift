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
    //    = ChartDataModel.init(dataModel: sampleData)
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

                    Chart {
                        BarMark(x: .value("name", successCount))
                            .cornerRadius(10)
                    }
                    .frame(height: 28)
                    .chartXScale(domain: 0...totalCount)
                    .chartXAxis {
                        AxisMarks(position: .bottom) { value in
                            AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 3]))
                            AxisTick(centered: true, stroke: StrokeStyle(dash: [1, 2]))
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
                
                HStack() {
                    Text("\(successCount)번의 성공")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color(uiColor: UIColor.orrGray700!))
                    Spacer()
                    Text("\(totalCount)번의 도전")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color(uiColor: UIColor.orrGray700!))
                }
            }
            .padding()
        }
        .frame(width: UIScreen.main.bounds.width - 32, height: 130)
        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.white))
    }
}

struct ChallengeChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeChartView(chartData: ChartDataModel(dataModel: sampleData), totalCount: 378, successCount: 64)
    }
}


struct PieChart: View {
    @State private var selectedCell: UUID = UUID()
    let chartColor: [Color] = [Color(uiColor: .lightGray), .yellow, .orange, .green, .blue, .red, .purple, Color(uiColor: .darkGray), .brown, .black]
    
    let dataSource: ChartDataModel
    var body: some View {
        ZStack {
            ForEach(dataSource.chartCellModel.indices) { index in
                PieChartCell(startAngle: self.dataSource.angle(for: dataSource.chartCellModel[index].numOfSolvedProblems),
                             endAngle: self.dataSource.startingAngle)
                .foregroundColor(chartColor[index])
            }
        }
    }
}

struct PieChartCell: Shape {
    let startAngle: Angle
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        // 중심점을 기준으로, 반지름만큼의 원을, startAngle -> endAngle로 시계방향으로 그리기
        let center = CGPoint.init(x: (rect.origin.x + rect.width)/2,
                                  y: (rect.origin.y + rect.height)/2)
        let radii = min(center.x, center.y)
        let path = Path { p in
            p.addArc(center: center,
                     radius: radii,
                     startAngle: startAngle,
                     endAngle: endAngle,
                     clockwise: true)
            p.addLine(to: center)
        }
        
        return path
    }
}

struct ChartCellModel: Identifiable {
    let id = UUID()
    
    var numOfSolvedProblems: CGFloat
    let level: String
}

final class ChartDataModel: ObservableObject {
    var chartCellModel: [ChartCellModel]
    var startingAngle = Angle(degrees: 0)
    private var lastBarEndAngle = Angle(degrees: 0)
    
    
    init(dataModel: [ChartCellModel]) {
        chartCellModel = dataModel
    }
    
    var totalNumberOfSolvedProblems: CGFloat {
        chartCellModel.reduce(CGFloat(0)) { (result, data) -> CGFloat in
            result + data.numOfSolvedProblems
        }
    }
    
    func angle(for value: CGFloat) -> Angle {
        if startingAngle != lastBarEndAngle {
            startingAngle = lastBarEndAngle
        }
        lastBarEndAngle += Angle(degrees: Double(value / totalNumberOfSolvedProblems) * 360 )
        return lastBarEndAngle
    }
}

let sampleData: [ChartCellModel] = [
    ChartCellModel(numOfSolvedProblems: 13, level: "v1"),
    ChartCellModel(numOfSolvedProblems: 13, level: "v2"),
    ChartCellModel(numOfSolvedProblems: 13, level: "v3"),
    ChartCellModel(numOfSolvedProblems: 13, level: "v4"),
    ChartCellModel(numOfSolvedProblems: 13, level: "v5"),
]
