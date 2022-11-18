//
//  ChallengeChartView.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/19.
//

import SwiftUI

struct ChallengeChartView: View {
    var body: some View {
        VStack {
            Text("차트 페이지 1")
        }
        .frame(width: UIScreen.main.bounds.width - 32, height: 400)
        .background(Color.yellow)
    }
}

struct ChallengeChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeChartView()
    }
}
