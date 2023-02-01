//
//  AddScheduleView.swift
//  CheckIt
//
//  Created by 조현호 on 2023/01/18.
//

import SwiftUI

struct AddScheduleView: View {
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @State private var place: String = ""
    @State private var memo: String = ""
    @State private var placeholderText: String = "메모(선택)"
    @State private var lateMin: Int = 0
    @State private var lateFee: Int = 0
    @State private var absentFee: Int = 0
    
    @EnvironmentObject var scheduleStore: ScheduleStore
    
    var body: some View {
        ScrollView {
            VStack(alignment:.leading, spacing: 20) {
                Text("일정 추가하기")
                    .font(.system(size: 24, weight: .semibold))
                
                Divider()
                
                Text("일정 정보")
                    .font(.system(size: 20, weight: .regular))
                
                // MARK: - 일정 정보 Section
                VStack(alignment:.leading, spacing: 20) {
                    
                    HStack(spacing: 12) {
                        customSymbols(name: "calendar")
                        
                        // MARK: - 시작 시간 DatePicker
                        // FIXME: - 미래 시간 선택되게 수정하기
                        DatePicker(selection: $startTime, in: ...Date(), displayedComponents: .date) {
                            Text("날짜를 선택해주세요.")
                        }
                        .onChange(of: startTime) {newValue in
                            
                        }
                    }
                    
                    HStack(spacing: 12) {
                        customSymbols(name: "clock")
                        // MARK: - 시작 시간 DatePicker
                        // FIXME: - 시작 시간이 종료 시간보다 뒤면 안되는 조건 추가하기
                        DatePicker("시작 시간", selection: $startTime,
                                   displayedComponents: .hourAndMinute)
                    }
                    
                    HStack(spacing: 12) {
                        customSymbols(name: "clock")
                        
                        // MARK: - 종료 시간 DatePicker
                        DatePicker("종료 시간", selection: $endTime,
                                   displayedComponents: .hourAndMinute)
                    }
                    
                    HStack(spacing: 12) {
                        customSymbols(name: "mapPin")
                        
                        // MARK: - 동아리 장소 TextField
                        TextField("동아리 장소를 입력해주세요!", text: $place)
                            .frame(width: 200)
                    }
                    
                    Spacer(minLength: 1)
                    
                    ZStack {
                        // MARK: - 동아리 메모 TextEditor
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
                }
                .padding(5)
                
                Divider()
                
                // MARK: - 출석 인정 시간 Section
                VStack(alignment: .leading, spacing: 25) {
                        Text("출석 인정 시간")
                            .font(.system(size: 20, weight: .regular))
                    
                        HStack {
                            customSymbols(name: "clock")
                                .padding(10)
                            
                            // MARK: - 출석 인정 시간 TextField
                            TextField("", value: $lateMin, format: .number)
                                .frame(width: 68)
                                .textFieldStyle(.roundedBorder)
                            
                            Text("분 전부터 ~ 5분 후까지")
                        }
                    
                    HStack(spacing: 35) {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Text("지각")
                                Image(systemName: "questionmark.circle.fill")
                                    .foregroundColor(.myBlack)
                            }
                            HStack {
                                // MARK: - 지각비 TextField
                                TextField("", value: $lateFee, format: .number)
                                    .frame(width: 68)
                                    .textFieldStyle(.roundedBorder)
                                Text("원")
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Text("결석")
                                Image(systemName: "questionmark.circle.fill")
                                    .foregroundColor(.myBlack)
                            }
                            HStack {
                                // MARK: - 결석비 TextField
                                TextField("", value: $absentFee, format: .number)
                                    .frame(width: 68)
                                    .textFieldStyle(.roundedBorder)
                                Text("원")
                            }
                        }
                    }
                    .padding(5)
                }
                
                Spacer()
                
                // MARK: - 일정 만들기 버튼
                Button {
                    let schedule = Schedule(id: UUID().uuidString, groupName: "허미니의또구동아리", lateFee: lateFee, absenteeFee: absentFee, location: place, startTime: Date(), endTime: Date(), agreeTime: lateMin, memo: placeholderText)
                    print(startTime, endTime)
                    scheduleStore.addSchedule(schedule)
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
