//
//  EditScheduleView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/02/08.
//

import SwiftUI
import AlertToast

struct ScheduleDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var groupStore: GroupStore
    @EnvironmentObject var scheduleStore: ScheduleStore
    @EnvironmentObject var attendanceStore: AttendanceStore
    
    @State private var memo: String = ""
    @State private var isEditSchedule: Bool = false
    @State private var isRemoveSchedule: Bool = false
    
    @Binding var showToast: Bool
    @Binding var toastMessage: String
    
    @State private var editSchedule: Schedule = Schedule(id: "", groupName: "", lateFee: 0, absenteeFee: 0, location: "", startTime: Date(), endTime: Date(), agreeTime: 0, memo: "", attendanceCount: 0, lateCount: 0, absentCount: 0, officiallyAbsentCount: 0)
    
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
                            //시작시점이 지나번 버튼 가리기
                            if Date().pastDateCompare(compareDate: schedule.startTime) {
                                Button {
                                    isEditSchedule.toggle()
                                } label: {
                                    Label("수정하기", systemImage: "highlighter")
                                }
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
            .toast(isPresenting: $showToast){
                AlertToast(displayMode: .banner(.slide), type: .regular, title: toastMessage)
            }
            
            .sheet(isPresented: $isEditSchedule) {
                EditScheduleView(schedule: $editSchedule, showToast: $showToast, toastMessage: $toastMessage, group: group)
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
                        
                        self.scheduleStore.scheduleList.removeAll {$0.id == schedule.id }
                        self.scheduleStore.recentSchedule.removeAll {$0.id == schedule.id}
                        
                        
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
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                }
            }
        }
        
        .onAppear {
            editSchedule = Schedule(
                id: schedule.id,
                groupName: schedule.groupName,
                lateFee: schedule.lateFee,
                absenteeFee: schedule.absenteeFee,
                location: schedule.location,
                startTime: schedule.startTime,
                endTime: schedule.endTime,
                agreeTime: schedule.agreeTime,
                memo: schedule.memo,
                attendanceCount: schedule.attendanceCount,
                lateCount: schedule.lateCount,
                absentCount: schedule.absentCount,
                officiallyAbsentCount: schedule.officiallyAbsentCount
            )
            print("editSchedule:",editSchedule)
        }
    }
}

//struct ScheduleDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleDetailView()
//    }
//}
