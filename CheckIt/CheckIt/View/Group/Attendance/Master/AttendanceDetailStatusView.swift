//
//  AttendanceDetailStatusView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/20.
//

import SwiftUI

struct AttendanceDetailStatusView: View {
    @State var attendanceStatus: [Attendance]
    var category: AttendanceCategory
    var schedule: Schedule
    
    @State var lateStatusAttendanceList: [Attendance]
    @EnvironmentObject var attendanceStore: AttendanceStore
    @State var changedLateStatusAttendanceList: [Attendance]
    var body: some View {
        VStack(alignment: .center) {
            if category == .lated { //지각일 경우 지각비 안내
                HStack {
                    Spacer()
                    Text("지각비 :")
                    Text("\(schedule.lateFee)원 / 건")
                }
                
            }
            makeView(.attendanced)
                .padding(.bottom)
            
            if category != .lated {
                ForEach(attendanceStatus.indices, id: \.self) { index in
                    LateCostCellView(data: $attendanceStatus[index], category: category)

                    Divider()
                        .frame(minWidth: UIScreen.main.bounds.width)
                }
                .padding(.vertical, 5)
            }
            if category == .lated {
                ForEach(changedLateStatusAttendanceList.indices, id: \.self) { index in
                    LateCostCellView(data: $changedLateStatusAttendanceList[index], category: category)

                    Divider()
                        .frame(minWidth: UIScreen.main.bounds.width)
                }
                .padding(.vertical, 5)
                Spacer() //지각일 경우 총 지각비 표시하기
                Text("총 지각비 \(schedule.lateFee * (changedLateStatusAttendanceList.filter({ $0.settlementStatus == false }).count))원")
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

        }
        .onDisappear {
            if category == .lated {
                print("언제 dis")
                for index in 0..<lateStatusAttendanceList.count {
                    if lateStatusAttendanceList[index] != changedLateStatusAttendanceList[index] {
                        print(changedLateStatusAttendanceList[index], "바뀐것만 뽀ㅃ자")
                        attendanceStore.updateAttendace(attendanceData: changedLateStatusAttendanceList[index]) //todo
                    }
                }
            }
        }
        .onChange(of: changedLateStatusAttendanceList) { newValue in
            print(changedLateStatusAttendanceList,"바뀌나?")
        }
    }
}

struct AttendanceDetailStatusView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceView()
    }
}
