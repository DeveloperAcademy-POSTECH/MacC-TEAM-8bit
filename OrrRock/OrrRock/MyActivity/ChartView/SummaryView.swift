//
//  SummaryView.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/19.
//

import SwiftUI

struct SummaryView: View {
    var body: some View {
        VStack {
            Text("나의 정보 제공")
        }
        .frame(width: UIScreen.main.bounds.width - 32, height: 200)
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(UIColor.orrWhite!)))
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}
