//
//  historyView.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/21.
//

import SwiftUI

struct HistoryView: View {
    let fromDate: Date?
    let tapEditButton: (() -> Void)
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                
                HStack(spacing: 0){
                    Label("", systemImage: "calendar")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(uiColor: UIColor.orrBlack!))
                    
                    Text("경력")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color(uiColor: UIColor.orrBlack!))
                }

                Spacer()
                
                Text("볼더링을 시작한 지 \n\(Calendar.current.dateComponents([.day], from: fromDate ?? Date(), to: Date()).day! + 1)일 지났습니다.")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(uiColor: UIColor.orrBlack!))
                    .padding(.top, 8)
                
                Spacer()
                
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
                .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color(.orrGray050Custom!)))
            }
            .frame(width: UIScreen.main.bounds.width - CGFloat(OrrPd.pd16.rawValue) * 4, height: 148, alignment: .topLeading)
        }
        .frame(width: UIScreen.main.bounds.width - CGFloat(OrrPd.pd16.rawValue) * 2, height: 180)
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.orrWhiteCustom ?? .white)))
    }
}
