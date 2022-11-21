//
//  ExportCardView.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/22.
//

import SwiftUI

struct ExportCardView: View {
    let firstDate: Date?
    let highestLevel: Int
    let homeGymName: String
    
    var body: some View {
        ZStack(alignment: .center) {
            Image("ExportCardLevel\(highestLevel)")
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
                        .foregroundColor(Color(uiColor: UIColor.orrGray100!))
                        
                    Text(homeGymName)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(uiColor: UIColor.orrGray100!))
                }
            }
            .padding(.top, 30)
            .padding(.bottom, 24)
        }
        .frame(width: 262, height: 398)
        .background(.clear)
        
    }
}
