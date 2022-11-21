//
//  MyCardView.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/21.
//

import SwiftUI

struct MyCardView: View {
    let firstDate: Date?
    
    var body: some View {
        ZStack(alignment: .center) {
            Image("CardLevel0")
                .resizable()
            
            VStack {
                Text("볼더링 클라이밍을 시작한 지")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(Color(uiColor: UIColor.orrWhite!))
                
                Text("\(Calendar.current.dateComponents([.day], from: firstDate ?? Date(), to: Date()).day! + 1)일")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(uiColor: UIColor.orrWhite!))
                
                Spacer()
                
                HStack {
                    Image("homegym icon")
                        .renderingMode(.template)
                        .foregroundColor(Color(uiColor: UIColor.orrWhite!))
                        
                    Text("나의 홈짐은?")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(uiColor: UIColor.orrWhite!))
                }
                
                Text("\("아띠 클라이밍")")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(Color(uiColor: UIColor.orrWhite!))
            }
            .padding(.top, 30)
            .padding(.bottom, 24)
        }
        .frame(width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.width - 32, alignment: .leading)
    }
}
