//
//  AttendanceCellView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/18.
//

import SwiftUI

struct AttendanceCellView: View {
    var body: some View {
        HStack {
            VStack(alignment:.leading) {
                Text("2023년 1월 20일") // 출석 날짜
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.bottom, 15)
                
                Spacer()
                
                HStack {
                    Text("출석")
                    Text("11")   //출석 횟수
                        .foregroundColor(.myGreen)
                        .bold()
                    
                    Divider().frame(height:20)
                    
                    Text("지각")
                    Text("1")   //지각 횟수
                        .foregroundColor(.myYellow)
                        .bold()
                    
                    Divider().frame(height:20)
                    
                    Text("결석")
                    Text("3")   //결석 횟수
                        .foregroundColor(.myRed)
                        .bold()
                    
                    Text("공결")
                        
                    Text("1")   //공결 횟수
                        .foregroundColor(.myRed)
                        .bold()
                }
                .foregroundColor(.black)
                
                Spacer()
            }
            .padding()
            Spacer()
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.myLightGray)
                .frame(height: 120)
            
        }
        .frame(height: 120)
        .padding()
    }
}

struct AttendanceCellView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceCellView()
    }
}
