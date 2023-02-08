//
//  EditScheduleView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/02/08.
//

import SwiftUI

struct ScheduleDetailView: View {
    @EnvironmentObject var userStore: UserStore
    
    @State private var memo: String = ""
    
    var group: Group
    var schedule: Schedule
    
    var isHost: Bool {
        group.hostID == userStore.user?.id ?? ""
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment:.leading) {
                Text("일정 정보")
                    .font(.system(size: 20, weight: .regular))
                
                // MARK: - 일정 정보 Section
                VStack(alignment:.leading, spacing: 22) {
                    
                    HStack(spacing: 12) {
                        customSymbols(name: "calendar")
                        
                        // MARK: - 날짜 DatePicker
                        Text("날짜")
                        
                        Spacer()
                        
                        Text(schedule.startTime.monthDayDateToString(date: schedule.startTime))
                    }
                    
                    HStack(spacing: 12) {
                        customSymbols(name: "clock")
                        
                        Text("시작 시간")
                        
                        Spacer()
                        
                        Text(schedule.startTime.hourMinuteDateToString(date: schedule.startTime))
                    }
                    
                    HStack(spacing: 12) {
                        customSymbols(name: "clock")
                        
                        Text("종료 시간")
                        
                        Spacer()
                        
                        Text(schedule.endTime.hourMinuteDateToString(date: schedule.endTime))
                    }
                    
                    HStack(spacing: 12) {
                        customSymbols(name: "mapPin")
                        
                        Text("장소")
                        
                        Spacer()
                        
                        Text(schedule.location)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Spacer(minLength: 1)
                    
                    ZStack {
                        // MARK: - 동아리 메모 TextEditor
                        TextEditor(text: $memo)
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
                        
                        Text("\(schedule.agreeTime)분 전부터 ~ 5분 후까지")
                    }
                    
                    HStack(spacing: 35) {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("지각")
                            
                            Text("\(schedule.lateFee)원")
                        }
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text("결석")
                            
                            Text("\(schedule.absenteeFee)원")
                        }
                    }
                    .padding(.bottom)
                    .padding(5)
                }
                
                Spacer()
            }
            .padding(.vertical)
            .padding(.horizontal, 10)
            
            .navigationBarTitle(schedule.startTime.yearMonthDayDateToString(date: schedule.startTime))
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Section {
                            Button {
                                
                            } label: {
                                Label("수정하기", systemImage: "highlighter")
                            }
                            
                            Button(role: .destructive) {
                                
                            } label: {
                                Label("삭제하기", systemImage: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                    .opacity(isHost ? 1 : 0)
                }
            }
            
            .onAppear {
                memo = schedule.memo
            }
        }
    }
}

//struct ScheduleDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleDetailView()
//    }
//}
