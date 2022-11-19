//
//  ChallengeChartView.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/19.
//  https://tutorial101.blogspot.com/2021/08/swiftui-pie-chart.html

import SwiftUI

struct ChallengeChartView: View {
    let chartData: ChartDataModel
//    = ChartDataModel.init(dataModel: sampleData)
    let totalCount: Int
    let successCount: Int
    
    var body: some View {
        ZStack {
            HStack {
                ZStack{
                    PieChart(dataSource: chartData)
                    Circle()
                        .foregroundColor(Color.white)
                        .padding(40)
                }
                Spacer()
                HStack{
                    VStack(alignment: .trailing) {
                        HStack(alignment: .bottom) {
                            Text("\(totalCount)")
                                .font(.system(size: 50))
                            Text("도전")
                                .font(.system(size: 30))
                        }
                        HStack(alignment: .bottom) {
                            Text("\(successCount)")
                                .font(.system(size: 50))
                            Text("성공")
                                .font(.system(size: 30))
                        }
                    }
                }
            }
            .padding()
        }
        .frame(width: UIScreen.main.bounds.width - 32, height: 240)
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
