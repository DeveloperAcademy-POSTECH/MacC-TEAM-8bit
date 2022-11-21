//
//  historyView.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/21.
//

import SwiftUI

struct HistoryView: View {
    let fromDate: Date?
    let tapEditButton: (() -> Void)
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Label("경력", systemImage: "calendar")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(uiColor: UIColor.orrBlack!))
                
                Text("볼더링 클라이밍을 시작한 지 \n\(Calendar.current.dateComponents([.day], from: fromDate ?? Date(), to: Date()).day! + 1)일 지났습니다.")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(uiColor: UIColor.orrBlack!))
                    .padding(.top, 8)
                
                HStack {
                    HStack {
                        Text("시작일")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(Color(uiColor: UIColor.orrBlack!))
                        
                        Text(fromDate?.timeToString() ?? "정보 없음")
                    }
                    Spacer()
                    Button {
                        tapEditButton()
                    } label: {
                        Text("편집")
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color(uiColor: UIColor.orrGray100!)))
            }
            .padding()
        }
        .frame(width: UIScreen.main.bounds.width - 32, height: 180)
        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.white))
    }
}
