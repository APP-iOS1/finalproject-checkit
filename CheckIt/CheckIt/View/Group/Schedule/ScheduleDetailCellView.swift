//
//  ScheduleDetailView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/02/08.
//

import SwiftUI

struct ScheduleDetailCellView: View {
    var schedule: Schedule
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 18)
                    .foregroundColor(Color.myLightGray)
                    .frame(height: UIScreen.screenHeight / 5.5)
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        customSymbols(name: "calendar")
                        // MARK: - 동아리 일정 날짜
                        Text("\(schedule.startTime, format:.dateTime.year().day().month())")
                    }
                    
                    HStack {
                        customSymbols(name: "clock")
                        // MARK: - 동아리 일정 시간
                        Text("\(schedule.startTime, format:.dateTime.hour().minute())")
                        Text("~")
                        Text("\(schedule.endTime, format:.dateTime.hour().minute())")
                        
                        Spacer()
                        
                        Image(systemName: "greaterthan")
                            .resizable()
                            .frame(width: 10, height: 15)
                            .foregroundColor(.gray)
                            .offset(x:10)
                    }
                    
                    HStack {
                        customSymbols(name: "mapPin")
                        // MARK: - 동아리 일정 장소
                        Text(schedule.location)
                    }
                }
                .padding(30)
                .foregroundColor(.black)
            }
        }
    }
}

//struct ScheduleDetailCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleDetailView()
//    }
//}
