//
//  AttendanceDetailStatusView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/20.
//

import SwiftUI

struct AttendanceDetailStatusView: View {
    var category: AttendanceCategory
    var schedule: Schedule
    @EnvironmentObject var attendanceStore: AttendanceStore
    @State var changedLatedStatusList: [Attendance] = []
    @State var changedAbsentStatusList: [Attendance] = []
    var body: some View {
        
        VStack(spacing: 0) {
            switch category {
            case .lated:
                HStack {
                    Spacer()
                    Text("지각비 :")
                    Text("\(schedule.lateFee)원 / 건")
                        .foregroundColor(.myGray)
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(.myGray)
                .frame(height: 20)
                .offset(y:-15)
                HStack {
                    HStack {
                        Text("[정산 여부] ")
                            .frame(width: 80)
                        Text("이름")
                    }
                    .offset(x: -20)
                    Spacer()
                    Text("출석현황")
                }
                .font(.system(size: 16, weight: .bold))                .padding(.horizontal, 40)
            case .absented:
                HStack {
                    Spacer()
                    Text("결석비 :")
                    Text("\(schedule.lateFee)원 / 건")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(.myGray)
                .frame(height: 20)
                .offset(y:-15)
                HStack {
                    HStack {
                        Text("[정산 여부] ")
                            .frame(width: 80)
                        Text("이름")
                    }
                    .offset(x: -20)
                    Spacer()
                    Text("출석현황")
                }
                .font(.system(size: 16, weight: .bold))
                .padding(.horizontal, 40)
            case .attendanced:
                HStack { }
                .frame(height: 20)
                HStack {
                    Text("이름")
                    Spacer()
                    Text("출석현황")
                }
                .font(.system(size: 16, weight: .bold))
                .padding(.horizontal, 40)
            case .officiallyAbsented:
                HStack { }
                .frame(height: 20)
                HStack {
                    Text("이름")
                    Spacer()
                    Text("출석현황")
                }
                .font(.system(size: 16, weight: .bold))
                .padding(.horizontal, 40)
            }
            switch category {
            case .attendanced:
                ScrollView {
                    ForEach(attendanceStore.attendanceStatusList.indices, id: \.self) { index in
                        NotPenaltyCostCellView(data: attendanceStore.attendanceStatusList[index], category: category)
                            .padding(.top)
                            .padding(.horizontal, 35)

                        Divider()
                    }
                }
            case .lated:
                ScrollView {
                    ForEach(changedLatedStatusList.indices, id: \.self) { index in
                        PenaltyCostCellView(data: $changedLatedStatusList[index], category: category)
                            .padding(.top)
                            .padding(.horizontal, 35)

                        Divider()
                    }
                }
                Spacer() //지각일 경우 총 지각비 표시하기
                HStack(spacing: 0) {
                    Text("미정산 지각비: ")
                        .font(.system(size: 20, weight: .bold))
//                        .padding(.leading, 20)
                    Text("\(schedule.lateFee * (changedLatedStatusList.filter({ $0.settlementStatus == false }).count)) 원")
                        .font(.system(size: 20, weight: .medium))
                    Spacer()
                }
            case .absented:
                ScrollView {
                    ForEach(changedAbsentStatusList.indices, id: \.self) { index in
                        PenaltyCostCellView(data: $changedAbsentStatusList[index], category: category)
                            .padding(.top)
                            .padding(.horizontal, 30)

                        Divider()
                            .frame(minWidth: UIScreen.main.bounds.width)
                    }
                }
                Spacer() //결석일 경우 총 결석비 표시하기
                HStack(spacing: 0) {
                    Text("미정산 결석비: ")
                        .font(.system(size: 20, weight: .bold))
//                        .padding(.leading, 20)
                    Text("\(schedule.lateFee * (changedAbsentStatusList.filter({ $0.settlementStatus == false }).count)) 원")
                        .font(.system(size: 20, weight: .medium))
                    Spacer()
                }
            case .officiallyAbsented:
                ScrollView {
                    ForEach(attendanceStore.officiallyAbsentedStatusList.indices, id: \.self) { index in
                        NotPenaltyCostCellView(data: attendanceStore.officiallyAbsentedStatusList[index], category: category)
                            .padding(.top)
                            .padding(.horizontal, 35)

                        Divider()
                    }
                    .padding(.vertical, 5)
                    
                }
            }
        }
        .padding(.top, 20)
        .onAppear {
            print(category, "?????/")
            Task {
                await attendanceStore.fetchStatusAttendance(scheduleID: schedule.id)
                changedLatedStatusList = attendanceStore.latedStatusList
                changedAbsentStatusList = attendanceStore.absentedStatusList
                
            }
            
        }
        .onDisappear {
            if category == .lated {
                print("언제 dis")
                for index in 0..<changedLatedStatusList.count {
                    if changedLatedStatusList[index] != attendanceStore.latedStatusList[index] {
                        print(changedLatedStatusList[index], "바뀐것만 뽀ㅃ자")
                        attendanceStore.updateSettlementStatus(attendanceData: changedLatedStatusList[index]) //todo
                    }
                }
            }
            if category == .absented {
                print("언제 dis")
                for index in 0..<changedAbsentStatusList.count {
                    if changedAbsentStatusList[index] != attendanceStore.absentedStatusList[index] {
                        print(changedAbsentStatusList[index], "바뀐것만 뽀ㅃ자")
                        attendanceStore.updateSettlementStatus(attendanceData: changedAbsentStatusList[index]) //todo
                    }
                }
            }
            print(attendanceStore.attendanceStatusList, "어텐던스 리스트")
            print(attendanceStore.latedStatusList, "어텐던스 리스트")
            print(attendanceStore.absentedStatusList, "어텐던스 리스트")
            print(attendanceStore.officiallyAbsentedStatusList, "어텐던스 리스트")
        }
    }
}

struct AttendanceDetailStatusView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceView()
    }
}
