//
//  EditScheduleView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/02/08.
//

import SwiftUI

struct ScheduleDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var groupStore: GroupStore
    @EnvironmentObject var scheduleStore: ScheduleStore
    @EnvironmentObject var attendanceStore: AttendanceStore
    
    @State private var memo: String = ""
    @State private var isRemoveSchedule: Bool = false
    
    @Binding var showToast: Bool
    @Binding var toastMessage: String
    
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
                                isRemoveSchedule.toggle()
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
            .alert("해당 일정을 삭제하시겠습니까?", isPresented: $isRemoveSchedule, actions: {
                Button("취소하기", role: .cancel) { }
                Button("삭제하기", role: .destructive) {
                    Task {
                        print("==scheduleStore.scheduleList==: \(scheduleStore.scheduleList)")
                        toastMessage = "일정 삭제가 완료 되었습니다."
                        async let attendanceId = await attendanceStore.getAttendanceId(schedule.id)
                        await attendanceStore.removeAttendance(schedule.id, attendanceId: attendanceId) // 1.
                        await groupStore.removeScheduleInGroup(group.id, scheduleList: scheduleStore.scheduleList, scheduleId: schedule.id) // 2.
                        await scheduleStore.removeSchedule(schedule.id)
                        print("삭제 성공")
                        
                        showToast.toggle()
                        dismiss()
                    }
                }
            }, message: {
                Text("해당 일정을 삭제하면\n일정과 출석에 대한 모든 정보가 사라집니다.")
                    .multilineTextAlignment(.center)
            })
            
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