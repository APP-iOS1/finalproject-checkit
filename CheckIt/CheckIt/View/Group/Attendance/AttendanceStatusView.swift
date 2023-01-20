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
                        .foregroundColor(Color.myOrange)
                        .frame(width: .infinity, height:100)
                        .overlay{
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.myOrange, lineWidth: 3)
                        }
                        .padding(.horizontal, 50)
                }
                
                VStack {
                    Rectangle()
                        .foregroundColor(Color.white)
                        .frame(width: .infinity, height:50)
                        .cornerRadius(10)
                        .offset(y: 25)
                        .padding(.horizontal, 50)
                }
                
                VStack {
                    Rectangle()
                        .foregroundColor(Color.white)
                        .frame(width: .infinity, height:20)
                        .offset(y: 10)
                        .padding(.horizontal, 50)
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("2023년 1월 20일")
                            .font(.headline)
                            .foregroundColor(.white)
                            .bold()
                        
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 45, height: 25)
                            .foregroundColor(.white)
                            .overlay{
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("myYellow"), lineWidth: 1)
                                Text("지각")
                                    .foregroundColor(Color("myYellow"))
                                    .font(.caption)
                                    .bold()
                            }
                    }
                    .offset(y: -10)
                    
                    HStack {
                        Text("오후 3:00 ~ 오후 7:00")
                            .font(.subheadline)
                        Spacer()
                        
                        Text("1000원")
                            .bold()
                    }
                    .offset(y: 10)
                }
                .padding(.horizontal, 70)
            }
            .padding(.vertical, 20)
            ZStack {
                VStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.myGreen)
                        .frame(width: .infinity, height:100)
                        .overlay{
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.myGreen, lineWidth: 3)
                        }
                        .padding(.horizontal, 50)
                }
                
                VStack {
                    Rectangle()
                        .foregroundColor(Color.white)
                        .frame(width: .infinity, height:50)
                        .cornerRadius(10)
                        .offset(y: 25)
                        .padding(.horizontal, 50)
                }
                
                VStack {
                    Rectangle()
                        .foregroundColor(Color.white)
                        .frame(width: .infinity, height:20)
                        .offset(y: 10)
                        .padding(.horizontal, 50)
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("2023년 1월 13일")
                            .font(.headline)
                            .foregroundColor(.white)
                            .bold()
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 45, height: 25)
                            .foregroundColor(.myGreen)
//                            .overlay{
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(Color("myYellow"), lineWidth: 1)
//                                Text("지각")
//                                    .foregroundColor(Color("myYellow"))
//                                    .font(.caption)
//                                    .bold()
//                            }
                    }
                    .offset(y: -10)
                    
                    HStack {
                        Text("오후 3:00 ~ 오후 7:00")
                            .font(.subheadline)
                        Spacer()
                    }
                    .offset(y: 10)
                }
                .padding(.horizontal, 70)
            }
            .padding(.bottom, 20)
            ZStack {
                VStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.myRed)
                        .frame(width: .infinity, height:100)
                        .overlay{
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.myRed, lineWidth: 3)
                        }
                        .padding(.horizontal, 50)
                }
                
                VStack {
                    Rectangle()
                        .foregroundColor(Color.white)
                        .frame(width: .infinity, height:50)
                        .cornerRadius(10)
                        .offset(y: 25)
                        .padding(.horizontal, 50)
                }
                
                VStack {
                    Rectangle()
                        .foregroundColor(Color.white)
                        .frame(width: .infinity, height:20)
                        .offset(y: 10)
                        .padding(.horizontal, 50)
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("2023년 1월 6일")
                            .font(.headline)
                            .foregroundColor(.white)
                            .bold()
                        
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 45, height: 25)
                            .foregroundColor(.white)
                            .overlay{
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("myRed"), lineWidth: 1)
                                Text("결석")
                                    .foregroundColor(Color("myRed"))
                                    .font(.caption)
                                    .bold()
                            }
                    }
                    .offset(y: -10)
                    
                    HStack {
                        Text("오후 3:00 ~ 오후 7:00")
                            .font(.subheadline)
                        Spacer()
                        
                        Text("3000원")
                            .bold()
                    }
                    .offset(y: 10)
                }
                .padding(.horizontal, 70)
            }
            .padding(.bottom, 20)
            ZStack {
                VStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.myBlack)
                        .frame(width: .infinity, height:100)
                        .overlay{
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.myBlack, lineWidth: 3)
                        }
                        .padding(.horizontal, 50)
                }
                
                VStack {
                    Rectangle()
                        .foregroundColor(Color.white)
                        .frame(width: .infinity, height:50)
                        .cornerRadius(10)
                        .offset(y: 25)
                        .padding(.horizontal, 50)
                }
                
                VStack {
                    Rectangle()
                        .foregroundColor(Color.white)
                        .frame(width: .infinity, height:20)
                        .offset(y: 10)
                        .padding(.horizontal, 50)
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("2022년 12월 30일")
                            .font(.headline)
                            .foregroundColor(.white)
                            .bold()
                        
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 45, height: 25)
                            .foregroundColor(.white)
                            .overlay{
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("myBlack"), lineWidth: 1)
                                Text("공결")
                                    .foregroundColor(Color("myBlack"))
                                    .font(.caption)
                                    .bold()
                            }
                    }
                    .offset(y: -10)
                    
                    HStack {
                        Text("오후 3:00 ~ 오후 7:00")
                            .font(.subheadline)
                        Spacer()
                    }
                    .offset(y: 10)
                }
                .padding(.horizontal, 70)
            }
        }
    }
}

struct AttendanceStatusView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceStatusView()
    }
}
