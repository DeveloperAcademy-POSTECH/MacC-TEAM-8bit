//
//  SummaryView.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/19.
//

import SwiftUI

struct SummaryView: View {
    let firstDate: Date?
    let highestLevel: Int
    let mostVisitedGymName: String
    let mostVisitedGymCount: Int
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("나에 대한 기록")
                .font(.title)
            Text("처음 클라이밍을 시작한 날짜")
            Text("\(firstDate?.timeToString() ?? "기록 없음")")
            Text("최고난이도 : V\(highestLevel)")
            Text("주로 방문하는 클라이밍장")
            Text("\(mostVisitedGymName) / \(mostVisitedGymCount)회")
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 32, height: 200, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(UIColor.orrWhite!)))
    }
}
