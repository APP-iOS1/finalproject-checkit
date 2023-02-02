//
//  PremiumRateView.swift
//  CheckIt
//
//  Created by 류창휘 on 2023/01/18.
//

import SwiftUI

struct premiumRateView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            Spacer()
            
            VStack(alignment: .center, spacing: 15) {
                // FIXME: - 로고 이미지 수정해야함
                Image("CheckItLogo")
                    .resizable()
                    .scaledToFit()
                
                Text("Premium 요금제")
                    .font(.system(size: 24, weight: .bold))
                
                HStack {
                    Image(systemName: "wonsign")
                        .font(.system(size: 16, weight: .bold))
                    
                    Text("3,900 / 월")
                        .font(.system(size: 22, weight: .bold))
                }
                .foregroundColor(.myRed)
                
                Text("동아리 최대 인원 수의 제한 해제, 광고 제거, Custom QR Code, Custom MapPin,\n등의 서비스를 제공합니다.")
                    .font(.system(size: 17, weight: .regular))
            }
            .padding(5)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("최대 인원 8명")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.yellow)
                    
                    Text("최대 인원 무제한")
                        .foregroundColor(.myGreen)
                }
                .font(.system(size: 20, weight: .bold))
                
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("광고 포함")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.yellow)
                    
                    
                    Text("광고 제거")
                        .foregroundColor(.myGreen)
                }
                .font(.system(size: 20, weight: .bold))
            }
            
            VStack(alignment: .leading, spacing: 5) {
                
                Text("Basic QR Code 제공")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.yellow)
                    
                    
                    Text("Custom QR Code")
                        .foregroundColor(.myGreen)
                }
                .font(.system(size: 20, weight: .bold))
            }
            
            VStack(alignment: .leading, spacing: 5) {
                
                Text("Basic MapPin 제공")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.yellow)
                    
                    
                    Text("Custom MapPin")
                        .foregroundColor(.myGreen)
                }
                .font(.system(size: 20, weight: .bold))
            }
            
            Spacer()
            
            // MARK: - 결제하기 버튼
            Button {
                dismiss()
            } label: {
                Text("결제하기")
                    .modifier(GruopCustomButtonModifier())
            }

            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct premiumRateView_Previews: PreviewProvider {
    static var previews: some View {
        premiumRateView()
    }
}
