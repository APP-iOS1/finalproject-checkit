//
//  OnBoardingView.swift
//  CheckIt
//
//  Created by 황예리 on 2023/02/13.
//

import SwiftUI

struct OnBoardingStep {
    let image: String
    let title: String
    let subTitle: String
    let description: String
}

private let onBoardingSteps = [
    OnBoardingStep(image: "checkItIcon", title: "위치 기반 서비스로 출석하기", subTitle: "QR code 출첵, 길찾기 기능", description: "200m 반경 안에서 출석 버튼이 활성화되어요!"),
    OnBoardingStep(image: "checkItIcon", title: "우리만의 동아리 운영하기", subTitle: "운영진 권한 부여 및 구성원 강퇴 기능", description: "방장은 초대 코드를 공유해서\n동아리에 초대할 수 있어요!"),
    OnBoardingStep(image: "checkItIcon", title: "일정별 출석부로 정산하기", subTitle: "출결 인정시간 및 지각비 설정 기능", description: "방장은 정산 여부를 체크할 수 있어요!")
]

struct OnBoardingView: View {
    @State private var currentStep = 0
    
    init() {
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Button {
                    self.currentStep = onBoardingSteps.count - 1
                } label: {
                    Text("건너뛰기")
                        .font(.system(size: 18, weight: .medium))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 10)
                        .foregroundColor(.gray)
                }
            }
            
            TabView(selection: $currentStep) {
                ForEach(0..<onBoardingSteps.count) { it in
                    VStack {
                        Image(onBoardingSteps[it].image)
                            .resizable()
                            .frame(width: UIScreen.screenWidth * 0.4, height: UIScreen.screenHeight * 0.25)
                        
                        Text(onBoardingSteps[it].title)
                            .font(.system(size: 20, weight: .bold))
                        
                        Text(onBoardingSteps[it].subTitle)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color.myGreen)
                            .padding(.top, 10)
                        
                        Text(onBoardingSteps[it].description)
                            .font(.system(size: 16, weight: .regular))
                            .multilineTextAlignment(.center)
                    }
                    .tag(it)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            HStack {
                ForEach(0..<onBoardingSteps.count) { it in
                    if it == currentStep {
                        Rectangle()
                            .frame(width: 20, height: 10)
                            .cornerRadius(10)
                            .foregroundColor(Color.myGreen)
                    } else {
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 24)
            }
            
            Button {
                if self.currentStep < onBoardingSteps.count - 1 {
                    self.currentStep += 1
                } else {
                    
                }
            } label: {
                Text(currentStep < onBoardingSteps.count - 1 ? "다음" : "시작하기")
                    .modifier(GruopCustomButtonModifier())
            }
            
        }
        .padding(.horizontal, 30)
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
