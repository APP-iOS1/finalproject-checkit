//
//  AttendanceStatusView.swift
//  CheckIt
//
//  Created by 조현호 on 2023/01/18.
//

import SwiftUI

struct AttendanceStatusView: View {
    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.myLightGray)
                        .frame(width: .infinity, height:100)
                        .padding(.horizontal, 40)
                }
                
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("2023년 1월 20일")
                            .font(.headline)
                            .bold()
                        
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 45, height: 25)
                            .foregroundColor(.white)
                            .overlay{
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.myOrange, lineWidth: 1)
                                Text("지각")
                                    .foregroundColor(Color.myOrange)
                                    .font(.caption)
                                    .bold()
                            }
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        Text("오후 3:00 ~ 오후 7:00")
                            .font(.subheadline)
                        Spacer()
                        
                        Text("1000원")
                            .bold()
                    }
                }
                .padding(.horizontal, 70)
            }
            .padding(.vertical, 10)
            ZStack {
                VStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.myLightGray)
                        .frame(width: .infinity, height:100)
                        .padding(.horizontal, 40)
                }
                
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("2023년 1월 13일")
                            .font(.headline)
                            .bold()
                        
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 45, height: 25)
                            .foregroundColor(.white)
                            .overlay{
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.myGreen, lineWidth: 1)
                                Text("출석")
                                    .foregroundColor(Color.myGreen)
                                    .font(.caption)
                                    .bold()
                            }
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        Text("오후 3:00 ~ 오후 7:00")
                            .font(.subheadline)
                        Spacer()
                        
//                        Text("-")
//                            .bold()
                    }
                }
                .padding(.horizontal, 70)
            }
            .padding(.vertical, 10)
            ZStack {
                VStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.myLightGray)
                        .frame(width: .infinity, height:100)
                        .padding(.horizontal, 40)
                }
                
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("2023년 1월 6일")
                            .font(.headline)
                            .bold()
                        
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 45, height: 25)
                            .foregroundColor(.white)
                            .overlay{
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.myRed, lineWidth: 1)
                                Text("결석")
                                    .foregroundColor(Color.myRed)
                                    .font(.caption)
                                    .bold()
                            }
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        Text("오후 3:00 ~ 오후 7:00")
                            .font(.subheadline)
                        Spacer()
                        
                        Text("3000원")
                            .bold()
                    }
                }
                .padding(.horizontal, 70)
            }
            .padding(.vertical, 10)
            ZStack {
                VStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.myLightGray)
                        .frame(width: .infinity, height:100)
                        .padding(.horizontal, 40)
                }
                
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("2022년 12월 30일")
                            .font(.headline)
                            .bold()
                        
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 45, height: 25)
                            .foregroundColor(.white)
                            .overlay{
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.myBlack, lineWidth: 1)
                                Text("공결")
                                    .foregroundColor(Color.myBlack)
                                    .font(.caption)
                                    .bold()
                            }
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        Text("오후 3:00 ~ 오후 7:00")
                            .font(.subheadline)
                        Spacer()
                        
//                        Text("-")
//                            .bold()
                    }
                }
                .padding(.horizontal, 70)
            }
            .padding(.vertical, 10)
        }
    }
}

struct AttendanceStatusView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceStatusView()
    }
}
