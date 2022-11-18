//
//  ChallengeChartView.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/19.
//  https://tutorial101.blogspot.com/2021/08/swiftui-pie-chart.html

import SwiftUI

struct ChallengeChartView: View {
    let chartData = ChartDataModel.init(dataModel: sampleData)
    
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
                            Text("378")
                                .font(.system(size: 50))
                            Text("도전")
                                .font(.system(size: 30))
                        }
                        HStack(alignment: .bottom) {
                            Text("64")
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
        ChallengeChartView()
    }
}


struct PieChart: View {
    @State private var selectedCell: UUID = UUID()
    
    let dataSource: ChartDataModel
    var body: some View {
        ZStack {
            ForEach(dataSource.chartCellModel) { solvedProblemOfLevel in
                PieChartCell(startAngle: self.dataSource.angle(for: solvedProblemOfLevel.numOfSolvedProblems),
                             endAngle: self.dataSource.startingAngle)
                    .foregroundColor(solvedProblemOfLevel.color)
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
    let color: Color
    
    let numOfSolvedProblems: CGFloat
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
    ChartCellModel(color: .red, numOfSolvedProblems: 13, level: "v1"),
    ChartCellModel(color: .orange, numOfSolvedProblems: 13, level: "v2"),
    ChartCellModel(color: .yellow, numOfSolvedProblems: 13, level: "v3"),
    ChartCellModel(color: .blue, numOfSolvedProblems: 13, level: "v4"),
    ChartCellModel(color: .green, numOfSolvedProblems: 13, level: "v5"),
]
