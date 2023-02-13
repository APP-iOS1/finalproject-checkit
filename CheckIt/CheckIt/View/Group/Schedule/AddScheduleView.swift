//
//  AddScheduleView.swift
//  CheckIt
//
//  Created by 조현호 on 2023/01/18.
//

import AlertToast
import SwiftUI

struct AddScheduleView: View {
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @State private var place: String = ""
    @State private var memo: String = ""
    @State private var placeholderText: String = "메모(선택)"
    @State private var agreeTime: Int = 0
    @State private var lateTime: Int = 0
    @State private var lateFee: Int = 0
    @State private var absentFee: Int = 0
    
    @State private var isLoading: Bool = false
    
    @ObservedObject var viewModel = WebViewModel()
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var scheduleStore: ScheduleStore
    @EnvironmentObject var attendanceStroe: AttendanceStore
    @EnvironmentObject var memberStore: MemberStore
    
    @Binding var showToast: Bool
    @Binding var toastMessage: String
    
    @State private var showAddressToast: Bool = false
    @State private var addressToastMessage: String = ""
    
    var group: Group
    
    
    var body: some View {
        ScrollView {
            VStack(alignment:.leading) {
                Text("일정 추가하기")
                    .font(.system(size: 24, weight: .semibold))
                    .padding(.top)
                
                Divider()
                
                Text("일정 정보")
                    .font(.system(size: 20, weight: .regular))
                
                // MARK: - 일정 정보 Section
                VStack(alignment:.leading, spacing: 22) {
                    
                    HStack(spacing: 12) {
                        customSymbols(name: "calendar")
                        
                        // MARK: - 날짜 DatePicker
                        DatePicker(selection: $startTime, in: Date()..., displayedComponents: .date) {
                            Text("날짜를 선택해주세요.")
                        }
                        .onChange(of: startTime) {newValue in
                            
                        }
                    }
                    
                    HStack(spacing: 12) {
                        customSymbols(name: "clock")
                        // MARK: - 시작 시간 DatePicker
                        DatePicker("시작 시간", selection: $startTime,
                                   displayedComponents: .hourAndMinute)
                    }
                    
                    HStack(spacing: 12) {
                        customSymbols(name: "clock")
                        
                        // MARK: - 종료 시간 DatePicker
                        DatePicker("종료 시간", selection: $endTime, in: startTime...,
                                   displayedComponents: .hourAndMinute)
                    }
                    
                    HStack(spacing: 12) {
                        customSymbols(name: "mapPin")
                        
                        ZStack {
                            Button {
                                self.viewModel.isPresentedWebView = true
                                
                            } label: {
                                ZStack(alignment: .leading) {
                                    Text("\(viewModel.result ?? "장소를 입력해주세요.")")
                                        .foregroundColor(.primary)
                                        .offset(x:2)
                                }
                            }
                        }
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
                    .padding(.bottom)
                
                // MARK: - 출석 인정 시간 Section
                VStack(alignment: .leading, spacing: 25) {
                        Text("출석 인정 시간")
                            .font(.system(size: 20, weight: .regular))
                    
                        HStack {
                            customSymbols(name: "clock")
                                .padding(10)
                            
                            // MARK: - 출석 인정 시간 TextField
                            TextField("", value: $agreeTime, format: .number)
                                .frame(width: 68)
                                .textFieldStyle(.roundedBorder)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.secondary, lineWidth: 0.5)
                                )
                            
                            Text("분 전부터 ~ 5분 후까지")
                        }
                    
                    Text("지각 인정 시간")
                        .font(.system(size: 20, weight: .regular))
                
                    HStack {
                        customSymbols(name: "clock")
                            .padding(10)
                        
                        Text("5분 후부터 ~ ")
                        // MARK: - 지각 인정 시간 TextField
                        TextField("", value: $lateTime, format: .number)
                            .frame(width: 68)
                            .textFieldStyle(.roundedBorder)
                        
                        Text("분 후까지")
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
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color.secondary, lineWidth: 0.5)
                                    )
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
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color.secondary, lineWidth: 0.5)
                                    )
                                Text("원")
                            }
                        }
                    }
                    .padding(.bottom)
                    .padding(5)
                }
                
                Spacer()
                
                // MARK: - 일정 만들기 버튼
                Button {
                    if viewModel.result == nil {
                        showAddressToast.toggle()
                        return
                    }
                    
                    showToast.toggle()
                    toastMessage = "일정 생성이 완료 되었습니다."
                    isLoading.toggle()
                    // 날짜정보와 시간정보를 하나의 문자열로 합침
                    let start = startTime.getDateString() + " " + startTime.getTimeString()
                    let end = startTime.getDateString() + " " + endTime.getTimeString()
                    
                    // 문자열을 기반으로 Date 인스턴스생성
                    let start1 = start.getAllTimeInfo()
                    let end1 = end.getAllTimeInfo()
                    
                    guard let location = viewModel.result else { fatalError() }
                    
                    var schedule = Schedule(
                        id: UUID().uuidString,
                        groupName: group.name,
                        lateFee: lateFee,
                        absenteeFee: absentFee,
                        location: location,
                        startTime: start1,
                        endTime: end1,
                        agreeTime: agreeTime,
                        lateTime: lateTime,
                        memo: memo,
                        attendanceCount: 0,
                        lateCount: 0,
                        absentCount: 0,
                        officiallyAbsentCount: 0
                    )
                    
                    Task {
                        schedule.absentCount = memberStore.members.count
                        await scheduleStore.addSchedule(schedule, group: group)
//                        var recent = scheduleStore.recentSchedule.filter({ recent in
//                            return recent.groupName == schedule.groupName
//                        })
                        let scheduleIdx = scheduleStore.recentSchedule.firstIndex { recent in
                            return recent.groupName == schedule.groupName
                        }
                        if (scheduleIdx != nil) {
                            if schedule.startTime.dateCompare(fromDate: scheduleStore.recentSchedule[scheduleIdx!].startTime) == "Past" {
                                scheduleStore.recentSchedule[scheduleIdx!] = schedule
                            }
                        } else {
                            scheduleStore.recentSchedule.append(schedule)
                        }
                        for member in memberStore.members {
                            var attendance = Attendance(id: "", scheduleId: schedule.id, attendanceStatus: "결석", settlementStatus: false)
                            attendance.id = member.uid
                            await attendanceStroe.addAttendance(attendance: attendance)
                        }
                    }
                    
                    dismiss()
                    
                } label: {
                    if isLoading {
                        ProgressView()
                            .modifier(GruopCustomButtonModifier())
                    } else {
                        Text("일정 만들기")
                            .modifier(ScheduleEditButton(disable: viewModel.result == nil ? true : false))
                    }
                }
                //.disabled(viewModel.result?.isEmpty ?? true)
            }
            .padding(.horizontal, 30)
            
        }

        .sheet(isPresented: $viewModel.isPresentedWebView) {
            WebView(url: "https://soletree.github.io/postNum/", viewModel: viewModel)
        }
        .toast(isPresenting: $showAddressToast) {
            AlertToast(displayMode: .banner(.pop), type: .error(.red), title: "일정 장소를 선택해 주세요.")
        }
        
    }
}

struct AddScheduleView_Previews: PreviewProvider {
    @State static private var showToast = false

    static var previews: some View {
        AddScheduleView(showToast: $showToast, toastMessage: .constant(""), group: Group.sampleGroup)
    }
}
