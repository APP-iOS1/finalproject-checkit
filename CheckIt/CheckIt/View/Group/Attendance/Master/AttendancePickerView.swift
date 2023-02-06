//
//  AttendancePickerView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/20.
//

import SwiftUI

struct AttendancePickerView: View {
    @Binding var selectedTap: AttendanceCategory
    var schedule: Schedule

    var body: some View {
        HStack {
            //출석
            Button {
                selectedTap = .attendanced
            } label: {
                VStack {
                    HStack {
                        Text(AttendanceCategory.attendanced.rawValue)
                            .foregroundColor(.myBlack)
                        Text("\(schedule.attendanceCount)")
                            .foregroundColor(.myGreen)
                    }
                    if selectedTap == .attendanced {
                        Capsule()
                            .foregroundColor(.black)
                            .frame(height: 2)
                    }
                    else {
                        Capsule()
                            .foregroundColor(.white)
                            .frame(height: 2)
                    }
                    
                }
            }

            //지각
            Button {
                selectedTap = .lated
            } label: {
                VStack {
                    HStack {
                        Text(AttendanceCategory.lated.rawValue)
                            .foregroundColor(.myBlack)
                        Text("\(schedule.lateCount)")
                            .foregroundColor(.myOrange)
                    }
                    if selectedTap == .lated {
                        Capsule()
                            .foregroundColor(.black)
                            .frame(height: 2)
                    }
                    else {
                        Capsule()
                            .foregroundColor(.white)
                            .frame(height: 2)
                    }
                    
                }
            }

            //결석
            Button {
                selectedTap = .absented
            } label: {
                VStack {
                    HStack {
                        Text(AttendanceCategory.absented.rawValue)
                            .foregroundColor(.myBlack)
                        Text("\(schedule.absentCount)")
                            .foregroundColor(.myRed)
                    }
                    if selectedTap == .absented {
                        Capsule()
                            .foregroundColor(.black)
                            .frame(height: 2)
                    }
                    else {
                        Capsule()
                            .foregroundColor(.white)
                            .frame(height: 2)
                    }
                    
                }
            }

            //공결
            Button {
                selectedTap = .officiallyAbsented
            } label: {
                VStack {
                    HStack {
                        Text(AttendanceCategory.officiallyAbsented.rawValue)
                            .foregroundColor(.myBlack)
                        Text("\(schedule.officiallyAbsentCount)")
                            .foregroundColor(.myBlack)
                    }
                    if selectedTap == .officiallyAbsented {
                        Capsule()
                            .foregroundColor(.black)
                            .frame(height: 2)
                    }
                    else {
                        Capsule()
                            .foregroundColor(.white)
                            .frame(height: 2)
                    }
                    
                }
            }

        }
    }
}


//struct AttendancePickerView_Previews: PreviewProvider {
//    @State static var selectedTap = AttendanceCategory.attendanced
//    static var previews: some View {
//        AttendancePickerView(selectedTap: $selectedTap, schedule: <#Schedule#>)
//    }
//}
