//
//  AddScheduleView.swift
//  CheckIt
//
//  Created by 조현호 on 2023/01/18.
//

import SwiftUI

struct AddScheduleView: View {
    @State var startTime: Date = Date()
    @State var endTime: Date = Date()
    @State var place: String = ""
    @State var memo: String = ""
    @State var placeholderText: String = "메모(선택)"
    @State var lateMin: Int = 0
    @State var lateFee: Int = 0
    @State var absentFee: Int = 0
    
    @EnvironmentObject var scheduleStore: ScheduleStore
    
    var body: some View {
        ScrollView {
            VStack(alignment:.leading, spacing: 25) {
                Text("일정 추가하기")
                    .font(.system(size: 24, weight: .semibold))
                
                Divider()
                
                // MARK: - 일정 정보 Section
                Section {
                    Text("일정 정보")
                        .font(.system(size: 20, weight: .regular))
                    
                    HStack {
                        customSymbols(name: "clock")
                        
                        // MARK: - 시작 시간 DatePicker
                        DatePicker("시작 시간을 입력하세요", selection: $startTime)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                    }
                    
                    HStack {
                        customSymbols(name: "mapPin")
                            .padding()
                        
                        VStack() {
                            TextField("동아리 장소를 입력해주세요", text: $place)
                                .frame(width: 200)
                            
                            Divider()
                                .frame(width: 200)
                        }
                    }
                    
                    //                ZStack(alignment: .leading) {
                    //                    if self.memo.isEmpty {
                    //                        TextEditor(text: $placeholderText)
                    //                            .padding(.horizontal,15)
                    //                            .padding(.vertical,10)
                    //                            .font(.subheadline)
                    //                            .foregroundColor(.gray)
                    //                            .multilineTextAlignment(.leading)
                    //                            .frame(height: 100)
                    //                            .background(Color.white)
                    //                            .overlay(
                    //                                RoundedRectangle(cornerRadius: 10)
                    //                                    .stroke(Color.gray, lineWidth: 2)
                    //                            )
                    //                            .cornerRadius(10)
                    //                            .padding(.bottom, 23)
                    //                            .disabled(true)
                    //                    }
                    //                    TextEditor(text: $memo)
                    //                        .padding(.horizontal,15)
                    //                        .padding(.vertical,10)
                    //                        .font(.subheadline)
                    //                        .lineSpacing(10)
                    //                        .multilineTextAlignment(.leading)
                    //                        .opacity(self.memo.isEmpty ? 0.25 : 1)
                    //                        .overlay(
                    //                            RoundedRectangle(cornerRadius: 10)
                    //                                .stroke(Color.myGray, lineWidth: 2)
                    //                        )
                    //                        .frame(height: 100)
                    //                        .padding(.bottom, 23)
                    //                }
                }
                
                Divider()
                
                /// 결석 기준 시간 정하기
                // MARK: - 일정 정보 Section
                Section {
                    HStack {
                        customSymbols(name: "clock")
                            .padding(10)
                        
                        Text("출석 인정 시간")
                            .font(.system(size: 20, weight: .regular))
                    }
                    
                    HStack {
                        HStack {
                            TextField("", value: $lateMin, format: .number)
                                .frame(width: 68)
                                .textFieldStyle(.roundedBorder)
                            
                            Text("분 전부터 ~ 5분 후까지")
                        }
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("지각")
                                Image(systemName: "questionmark.circle.fill")
                                    .foregroundColor(.myGray)
                            }
                            HStack {
                                TextField("", value: $lateFee, format: .number)
                                    .frame(width: 68)
                                    .textFieldStyle(.roundedBorder)
                                Text("원")
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("결석")
                                Image(systemName: "questionmark.circle.fill")
                                    .foregroundColor(.myGray)
                            }
                            HStack {
                                TextField("", value: $absentFee, format: .number)
                                    .frame(width: 68)
                                    .textFieldStyle(.roundedBorder)
                                Text("원")
                            }
                        }
                    }
                }
                
                // MARK: - 일정 만들기 버튼
                Button {
                    let schedule = Schedule(id: UUID().uuidString, groupName: "허미니의또구동아리", lateFee: lateFee, absenteeFee: absentFee, location: place, startTime: Date(), endTime: Date(), agreeTime: lateMin, memo: placeholderText)
                } label: {
                    Text("일정 만들기")
                        .modifier(GruopCustomButtonModifier())
                }
            }
            .padding(.horizontal, 30)
        }
    }
}

struct AddScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        AddScheduleView()
    }
}
