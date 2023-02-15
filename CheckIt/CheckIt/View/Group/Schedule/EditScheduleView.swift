//
//  EditScheduleView.swift
//  CheckIt
//
//  Created by 조현호 on 2023/02/09.
//

import SwiftUI

struct EditScheduleView: View {
   
    @State private var placeholderText: String = "메모(선택)"
    
    @Binding var schedule: Schedule
    
    @State var isShowingWebView: Bool = false
    @State var bar = true
    @State private var isLoading: Bool = false
    
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var scheduleStore: ScheduleStore
    @EnvironmentObject var attendanceStroe: AttendanceStore
    @EnvironmentObject var memberStore: MemberStore
    
    @Binding var showToast: Bool
    @Binding var toastObj: ToastMessage
    @State var address: String?
    var group: Group
    enum Field: Hashable {
        case memo
        case attendanceTime
        case lateTime
        case lateCost
        case absentCost
    }
    @FocusState private var focusedField: Field?
    
    @State var coordinate: [Double] = [0,0]
    @State var showAddressSheet: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment:.leading) {
                    Text("일정 수정하기")
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
                            DatePicker(selection: $schedule.startTime, in: Date()..., displayedComponents: .date) {
                                Text("날짜를 선택해주세요.")
                            }
                            .onChange(of: schedule.startTime) {newValue in
                                
                            }
                        }
                        
                        HStack(spacing: 12) {
                            customSymbols(name: "clock")
                            // MARK: - 시작 시간 DatePicker
                            DatePicker("시작 시간", selection: $schedule.startTime,
                                       displayedComponents: .hourAndMinute)
                        }
                        
                        HStack(spacing: 12) {
                            customSymbols(name: "clock")
                            
                            // MARK: - 종료 시간 DatePicker
                            DatePicker("종료 시간", selection: $schedule.endTime, in: schedule.startTime...,
                                       displayedComponents: .hourAndMinute)
                        }
                        
                        HStack(spacing: 12) {
                            customSymbols(name: "mapPin")
                            
                            ZStack {
                                Button {
                                    showAddressSheet = true
                                } label: {
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .frame(width: 250)
                                            .foregroundColor(Color.white)
                                        
                                        Text(address ?? schedule.location)
                                            .foregroundColor(Color.black)
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 1)
                        
                        ZStack {
                            // MARK: - 동아리 메모 TextEditor
                            if schedule.memo.isEmpty {
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
                            TextEditor(text: $schedule.memo)
                                .padding(.horizontal,15)
                                .padding(.vertical,10)
                                .font(.subheadline)
                                .lineSpacing(10)
                                .multilineTextAlignment(.leading)
                                .opacity(schedule.memo.isEmpty ? 0.25 : 1)
                                .focused($focusedField, equals: .memo)
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
                                TextField("", value: $schedule.agreeTime, format: .number)
                                    .frame(width: 68)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.numberPad)
                                    .focused($focusedField, equals: .attendanceTime)
                                
                                Text("분 전부터 ~ 5분 후까지")
                            }
                        
                        Text("지각 인정 시간")
                            .font(.system(size: 20, weight: .regular))
                        
                        HStack {
                            customSymbols(name: "clock")
                                .padding(10)
                            
                            Text("5분 후부터 ~ ")
                            // MARK: - 지각 인정 시간 TextField
                            TextField("", value: $schedule.lateTime, format: .number)
                                .frame(width: 68)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numberPad)
                                .focused($focusedField, equals: .lateTime)
                            
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
                                    TextField("", value: $schedule.lateFee, format: .number)
                                        .frame(width: 68)
                                        .textFieldStyle(.roundedBorder)
                                        .focused($focusedField, equals: .lateCost)
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
                                    TextField("", value: $schedule.absenteeFee, format: .number)
                                        .frame(width: 68)
                                        .textFieldStyle(.roundedBorder)
                                        .focused($focusedField, equals: .absentCost)
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
                        isLoading.toggle()
                        // 날짜정보와 시간정보를 하나의 문자열로 합침
                        let start = schedule.startTime.getDateString() + " " + schedule.startTime.getTimeString()
                        let end = schedule.startTime.getDateString() + " " + schedule.endTime.getTimeString()
                        
                        // 문자열을 기반으로 Date 인스턴스생성
                        let start1 = start.getAllTimeInfo()
                        let end1 = end.getAllTimeInfo()
                        
                        
                        let coordinateResult = (address == nil) ?
                        schedule.coordinate : coordinate
                       
                            let newSchedule = Schedule(
                                id: schedule.id,
                                groupName: group.name,
                                lateFee: schedule.lateFee,
                                absenteeFee: schedule.absenteeFee,
                                location: address ?? schedule.location,
                                startTime: start1,
                                endTime: end1,
                                agreeTime: schedule.agreeTime,
                                lateTime: schedule.lateTime,
                                memo: schedule.memo,
                                attendanceCount: schedule.attendanceCount,
                                lateCount: schedule.lateCount,
                                absentCount: schedule.absentCount,
                                officiallyAbsentCount: schedule.officiallyAbsentCount,
                                coordinate: coordinateResult
                            )
                            
                            
                        Task {
                            await scheduleStore.updateSchedule(newSchedule, group: group)
                            //await scheduleStore.fetchRecentSchedule(groupName: group.name)
                        
                        
                        var index = self.scheduleStore.scheduleList.firstIndex{ $0.id == schedule.id }
                        self.scheduleStore.scheduleList[index ?? -1] = newSchedule
                        
                        // MARK: - 일정 수정 시 캘린더 실시간 연동을 위한 코드
                        if let calendarIndex = self.scheduleStore.calendarSchedule.firstIndex(where: { $0.id == schedule.id }) {
                            self.scheduleStore.calendarSchedule[calendarIndex] = newSchedule
                        }
                        
                        // MARK: - 일정 수정 시 출석체크뷰 카드 내용 업데이트를 위한 코드
                        if let recentIndex = self.scheduleStore.recentSchedule.firstIndex(where: { $0.id == schedule.id }) {
                            self.scheduleStore.recentSchedule[recentIndex] = newSchedule
                        }
                        toastObj.message = "일정 수정이 완료되었습니다."
                        toastObj.type = .competion
                        
                        dismiss()
                        showToast.toggle()
                        print("schedule:",schedule)
                        //                    print("recentSchedule \(scheduleStore.recentSchedule)")
                        //                    print("index \(index)")
                    }
                    } label: {
                        if isLoading {
                            ProgressView()
                                .modifier(GruopCustomButtonModifier())
                        } else {
                            Text("일정 수정하기")
                                .modifier(GruopCustomButtonModifier())
                        }
                    }

                    
                }
                .padding(.horizontal, 30)
                
            }
            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button {
                                        if focusedField == .memo {
                                            focusedField = .attendanceTime
                                        }
                                        else if focusedField == .attendanceTime {
                                            focusedField = .lateTime
                                        }
                                        else if focusedField == .lateTime {
                                            focusedField = .lateCost
                                        }
                                        else if focusedField == .lateCost {
                                            focusedField = .absentCost
                                        }
                                        else if focusedField == .absentCost {
                                            focusedField = nil
                                        }
                                    } label: {
                                        Text(focusedField == .absentCost ? "닫기" : "다음")
                                    }
                
                                }
            }
        }
        .sheet(isPresented: $showAddressSheet) {
            PickAddressMapView(coordinateList: $coordinate, isPresented: $showAddressSheet, address: $address)
            
        }
        
    }
    
   
}

//MARK: - addressToCoordinate
func addressToCoordinate(address: String) async -> [Double] {
    guard let coordinateString = await GeoCodingService.getCoordinateFromAddress(address: address)
    else { return [0.0, 0.0] }
    return [Double(coordinateString[0]) ?? 0.0, Double(coordinateString[1]) ?? 0.0]
    
} // - addressToCoordinate

//struct EditScheduleView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditScheduleView()
//    }
//}
