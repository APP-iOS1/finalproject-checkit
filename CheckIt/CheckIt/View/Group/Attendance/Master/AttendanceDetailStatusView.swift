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
        
        VStack(alignment: .center) {
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
            case .absented:
                HStack {
                    Spacer()
                    Text("결석비 :")
                    Text("\(schedule.lateFee)원 / 건")

                }
                .foregroundColor(.myGray)
                .frame(height: 20)
            case .attendanced:
                HStack { }
                .frame(height: 20)
            case .officiallyAbsented:
                HStack { }
                .frame(height: 20)
            }
            makeView(.attendanced)
                .padding(.bottom)
            switch category {
            case .attendanced:
                ForEach(attendanceStore.attendanceStatusList.indices, id: \.self) { index in
                    NotPenaltyCostCellView(data: attendanceStore.attendanceStatusList[index], category: category)

                    Divider()
                        .frame(minWidth: UIScreen.main.bounds.width)
                }
                .padding(.vertical, 5)
            case .lated:
                ForEach(changedLatedStatusList.indices, id: \.self) { index in
                    PenaltyCostCellView(data: $changedLatedStatusList[index], category: category)

                    Divider()
                        .frame(minWidth: UIScreen.main.bounds.width)
                }
                .padding(.vertical, 5)
                Spacer() //지각일 경우 총 지각비 표시하기
                Text("총 지각비 \(schedule.lateFee * (changedLatedStatusList.filter({ $0.settlementStatus == false }).count))원")
            case .absented:
                ForEach(changedAbsentStatusList.indices, id: \.self) { index in
                    PenaltyCostCellView(data: $changedAbsentStatusList[index], category: category)

                    Divider()
                        .frame(minWidth: UIScreen.main.bounds.width)
                }
                .padding(.vertical, 5)
                Spacer() //지각일 경우 총 지각비 표시하기
                Text("총 결석비 \(schedule.lateFee * (changedAbsentStatusList.filter({ $0.settlementStatus == false }).count))원")
            case .officiallyAbsented:
                ForEach(attendanceStore.officiallyAbsentedStatusList.indices, id: \.self) { index in
                    NotPenaltyCostCellView(data: attendanceStore.officiallyAbsentedStatusList[index], category: category)

                    Divider()
                        .frame(minWidth: UIScreen.main.bounds.width)
                }
                .padding(.vertical, 5)
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
    }
    
    func makeView(_ status: AttendanceCategory) -> some View {
        HStack {
            switch status {
            case .attendanced:
                Text("이름")
                Spacer()
                Text("출석현황")
            case .lated:
                Text("이름")
                Spacer()
                Text("출석현황")
            case .absented:
                Text("이름")
                Spacer()
                Text("출석현황")
            case .officiallyAbsented:
                Text("이름")
                Spacer()
                Text("출석현황")
            }
        }
        .font(.title3)
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
