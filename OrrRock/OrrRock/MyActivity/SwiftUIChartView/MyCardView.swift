//
//  MyCardView.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/21.
//

import SwiftUI

struct MyCardView: View {
    let firstDate: Date?
    let highestLevel: Int
    let homeGymName: String
    
    var delegate: MyCardViewDelegate?
    
    @GestureState var isDetectingLongPress = false
    @State var completedLongPress = false
    
    var size: CGFloat = UIScreen.main.bounds.width - 50
    
    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 0.5)
            .updating($isDetectingLongPress) { currentState, gestureState,
                transaction in
                gestureState = currentState
                transaction.animation = Animation.spring()
                
            }
            .onEnded { finished in
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    HapticManager.instance.impact(style: .heavy)
                    delegate?.longPressedCardView()
                }
                self.completedLongPress = finished
                
            }
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            if highestLevel >= 0 {
                Image("CardLevel\(highestLevel)")
                    .resizable()
                
                VStack {
                    Text("볼더링을 시작한 지")
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
                        
                        Text("나의 홈짐은?")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color(uiColor: UIColor.orrGray100!))
                    }
                    
                    Text("\(homeGymName)")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(Color(uiColor: UIColor.orrWhite!))
                }
                .padding(.top, 30)
                .padding(.bottom, 24)
            } else {
                Image("CardLevel0")
                    .resizable()
                VStack {
                    Text("볼더링을 시작한 지")
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
                        
                        Text("나의 홈짐은?")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color(uiColor: UIColor.orrGray100!))
                    }
                    
                    Text("아직 기록이 없어요")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(Color(uiColor: UIColor.orrWhite!))
                }
                .padding(.top, 30)
                .padding(.bottom, 24)
            }
        }
        .frame(width: self.isDetectingLongPress ?
               size * 1.03 :
                size, height: self.isDetectingLongPress ?
               size * 1.03:
                size , alignment: .center)
        .gesture(longPress)
    }
    
}
