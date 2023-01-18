//
//  PremiumRateView.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/18.
//

import SwiftUI

struct premiumRateView: View {
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            Spacer()
            
            VStack(alignment: .center, spacing: 20) {
                Text("Premium 요금제")
                    .font(.largeTitle).bold()
                
                HStack {
                    Image(systemName: "wonsign")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("3,900 / 월")
                        .font(.title).bold()
                }
                .foregroundColor(.myRed)
                
                Text("동아리 최대 인원 수의 제한 해제,\n광고 제거, Custom QR Code,\nCustom MapPin, 등의 서비스를 제공합니다.")
                    .font(.title2)
            }
            .padding(5)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("최대 인원 8명")
                    .font(.title3)
                    .foregroundColor(.myGray)
                
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.myYellow)
                    
                    Text("최대 인원 무제한")
                        .foregroundColor(.myGreen)
                }
                .font(.title).bold()
                
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("광고 포함")
                    .font(.title3)
                .foregroundColor(.myGray)
                
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.myYellow)

                    
                    Text("광고 제거")
                        .foregroundColor(.myGreen)
                }
                .font(.title).bold()
            }
            
            VStack(alignment: .leading, spacing: 5) {
                
                Text("Basic QR Code 제공")
                    .font(.title3)
                    .foregroundColor(.myGray)
                
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.myYellow)
                    
                    
                    Text("Custom QR Code")
                        .foregroundColor(.myGreen)
                }
                .font(.title).bold()
            }
            
            VStack(alignment: .leading, spacing: 5) {
                
                Text("Basic MapPin 제공")
                    .font(.title3)
                    .foregroundColor(.myGray)

                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.myYellow)

                    
                    Text("Custom MapPin")
                        .foregroundColor(.myGreen)
                }
                .font(.title).bold()
            }
            
            Button(action: {}){
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.myGreen)
                    .frame(width: .infinity, height: 60)
                    .overlay {
                        Text("결제하기")
                            .font(.title3)
                            .foregroundColor(.white)
                            .bold()
                    }
            }.padding(.vertical, 25)

        }
        .padding(.horizontal, 35)
    }
}

struct premiumRateView_Previews: PreviewProvider {
    static var previews: some View {
        premiumRateView()
    }
}
