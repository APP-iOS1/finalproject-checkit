//
//  LogoutAlert.swift
//  CheckIt
//
//  Created by sole on 2023/02/13.
//

import SwiftUI

struct LogoutAlert: View {
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var groupStore: GroupStore
    @EnvironmentObject var scheduleStore: ScheduleStore
    @EnvironmentObject var attendanceStore: AttendanceStore
    @EnvironmentObject var memberStore: MemberStore
    
    @Binding var cancelButtonTapped: Bool
    var body: some View {
        
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .frame(width: 250, height: 130)
            VStack {
                Text("로그아웃하시겠습니까?")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.top, 25)
                  
                
                HStack {
                    Button {
                        cancelButtonTapped = false
                        
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 100, height: 50)
                            .foregroundColor(.myGray)
                            .overlay {
                                Text("취소하기")
                                    .foregroundColor(.black)
                                    .font(.system(size: 16, weight: .bold))
                            }
                    }
                    .padding(.trailing, 18)
                    
                    
                    Button {
                        userStore.signOut()
                        resetStoresData()
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 100, height: 50)
                            .foregroundColor(.myGreen)
                            .overlay {
                                Text("로그아웃")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .bold))
                            }
                    }
                    .padding(.leading, 0)
                    
                    
                }
                .padding(.bottom, 27)
            }
        } // - ZStack
        .frame(height: 200)
    }
    
    func resetStoresData() {
        userStore.resetData()
        groupStore.resetData()
        scheduleStore.resetData()
        attendanceStore.resetData()
        memberStore.resetData()
    }
    
}


