//
//  AddScheduleView.swift
//  CheckIt
//
//  Created by 조현호 on 2023/01/18.
//

import SwiftUI

struct AddScheduleView: View {
    @State var date: String = ""
    @State var startTime: String = ""
    @State var endTime: String = ""
    @State var place: String = ""
    @State var memo: String = ""
    @State var placeholderText: String = "메모(선택)"
    
    @State var absentMin: String = ""
    @State var lateMin: String = ""
    
    @State var lateFee: String = ""
    @State var absentFee: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment:.center){
                HStack {
                    Text("일정 추가하기")
                        .font(.title.bold())
                    Spacer()
                }
                
                // 일정 정보
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .frame(width: .infinity, height:300)
                        .overlay{
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.myOrange, lineWidth: 1)
                        }
                    HStack {
                        VStack(alignment:.leading){
                            Text("일정 정보")
                                .font(.title3)
                                .padding(.top,7)
                            
                            HStack{
                                customSymbols(name: "calendar")
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.myGreen)
                                ZStack {
                                    Rectangle()
                                        .frame(width: 200, height: 0.4)
                                        .padding(.top,25)
                                    TextField("날짜", text: $date)
                                        .frame(width: 200)
                                }
                            }
                            .padding(.bottom,7)
                            
                            HStack {
                                customSymbols(name: "clock")
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.myGreen)
                                ZStack {
                                    Rectangle()
                                        .frame(width: 65, height: 0.4)
                                        .padding(.top,25)
                                    TextField("시작 시간", text: $startTime)
                                        .frame(width: 65)
                                }
                                Text("~")
                                ZStack {
                                    Rectangle()
                                        .frame(width: 65, height: 0.4)
                                        .padding(.top,25)
                                    TextField("종료 시간", text: $endTime)
                                        .frame(width: 65)
                                }
                            }
                            .padding(.bottom,7)
                            
                            HStack{
                                customSymbols(name: "mapPin")
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.myGreen)
                                ZStack {
                                    Rectangle()
                                        .frame(width: 200, height: 0.4)
                                        .padding(.top,25)
                                    TextField("동아리 장소를 입력해주세요", text: $place)
                                        .frame(width: 200)
                                }
                            }
                            .padding(.bottom,7)
                            
                            ZStack(alignment: .leading) {
                                if self.memo.isEmpty {
                                    TextEditor(text: $placeholderText)
                                        .padding(.horizontal,15)
                                        .padding(.vertical,10)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.leading)
                                        .frame(height: 100)
                                        .background(Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray, lineWidth: 2)
                                        )
                                        .cornerRadius(10)
                                        .padding(.bottom, 23)
                                        .disabled(true)
                                }
                                TextEditor(text: $memo)
                                    .padding(.horizontal,15)
                                    .padding(.vertical,10)
                                    .font(.subheadline)
                                    .lineSpacing(10)
                                    .multilineTextAlignment(.leading)
                                    .opacity(self.memo.isEmpty ? 0.25 : 1)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.myGray, lineWidth: 2)
                                    )
                                    .frame(height: 100)
                                    .padding(.bottom, 23)
                            }
                            .offset(x:-6)
                            
                        }
                        .padding(.leading, 20)
                        Spacer()
                    }
                }
                .padding(.vertical)
                
                // 결석 기준 시간 정하기
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .frame(width: .infinity, height:180)
                        .overlay{
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.myOrange, lineWidth: 1)
                        }
                    HStack {
                        VStack(alignment:.leading){
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(.myGreen)
                                
                                Text("출석 인정 시간")
                                    .font(.title3)
                            }
                            
                            HStack {
                                HStack {
                                    TextField("", text: $lateMin)
                                        .frame(width: 68)
                                        .textFieldStyle(.roundedBorder)
                                    Text("분 전 ~ 시작 시간 5분")
                                }
                                .padding(.vertical, 7)
                            }
                            .padding(.horizontal, 30)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("지각")
                                        Image(systemName: "questionmark.circle.fill")
                                            .foregroundColor(.myGray)
                                    }
                                    HStack {
                                        TextField("", text: $lateFee)
                                            .frame(width: 68)
                                            .textFieldStyle(.roundedBorder)
                                        Text("원")
                                    }
                                }
                                Spacer()
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("결석")
                                        Image(systemName: "questionmark.circle.fill")
                                            .foregroundColor(.myGray)
                                    }
                                    HStack {
                                        TextField("", text: $absentFee)
                                            .frame(width: 68)
                                            .textFieldStyle(.roundedBorder)
                                        Text("원")
                                    }
                                }
                            }
                            .padding(.horizontal, 30)
                        }
                        Spacer()
                    }
                    .padding(.leading, 20)
                    
                }
                
                // 일정 만들기 버튼
                Button {
                    
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: .infinity, height: 60)
                            .foregroundColor(Color.myGreen)
                        Text("일정 만들기")
                            .foregroundColor(.white)
                            .font(.title3.bold())
                    }
                }
                .padding(.vertical, 20)
            }
            //모든 뷰 맞춤 패딩
            .padding(.horizontal, 30)
        }
    }
}

struct AddScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        AddScheduleView()
    }
}
