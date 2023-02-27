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
                .frame(width: UIScreen.screenWidth * 0.7, height: UIScreen.screenHeight * 0.2)
            VStack {
                Text("로그아웃하시겠습니까?")
                    .font(.system(size: UIScreen.screenHeight * 0.025, weight: .bold))
                    .padding(UIScreen.screenHeight * 0.03)
                    .padding(.top, UIScreen.screenHeight * 0.01)
                    
                  
                
                HStack {
                    Button {
                        cancelButtonTapped = false
                        
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: UIScreen.screenWidth * 0.22, height: UIScreen.screenHeight * 0.06)
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
                            .frame(width: UIScreen.screenWidth * 0.22, height: UIScreen.screenHeight * 0.06)
                            .foregroundColor(.myGreen)
                            .overlay {
                                Text("로그아웃")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .bold))
                            }
                    }
                    .padding(.leading, 0)
                    
                    
                }
//                .padding(.top, 27)
            }
        } // - ZStack
        .frame(height: UIScreen.screenHeight * 0.7)
    }
    
    func resetStoresData() {
        userStore.resetData()
        groupStore.resetData()
        scheduleStore.resetData()
        attendanceStore.resetData()
        memberStore.resetData()
    }
    
}


