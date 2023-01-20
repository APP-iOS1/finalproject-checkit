//
//  GroupScheduleView.swift
//  CheckIt
//
//  Created by 조현호 on 2023/01/18.
//

import SwiftUI

struct GroupScheduleView: View {
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    
                    NavigationLink {
                        AddScheduleView()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom)
                
                ScrollView {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color("myLightGray"))
                            .frame(width: .infinity, height:160)
                        
                        HStack {
                            VStack(alignment: .leading){
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 45, height: 25)
                                    .foregroundColor(.white)
                                    .overlay{
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color("myGreen"), lineWidth: 1)
                                        Text("출석")
                                            .foregroundColor(Color("myGreen"))
                                            .font(.caption)
                                    }
                                
                                HStack {
                                    Image(systemName: "mappin.and.ellipse")
                                    Text("신촌 베이스볼클럽")        //위치
                                }
                                .padding(.top, 5)
                                
                                HStack {
                                    Image(systemName: "calendar")
                                    Text("3월 17일")              //날짜
                                    
                                }
                                .padding(.vertical, 5)
                                
                                HStack {
                                    Image(systemName: "clock")
                                    Text("오후 3:00 ~ 오후 7:00")  //시간
                                }
                                .padding(.bottom, 5)
                                
                            }
                            
                            Spacer()
                        }
                        .padding(.leading, 20)
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 40)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color("myLightGray"))
                            .frame(width: .infinity, height:160)
                        
                        HStack {
                            VStack(alignment: .leading){
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 45, height: 25)
                                    .foregroundColor(.white)
                                    .overlay{
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color("myYellow"), lineWidth: 1)
                                        Text("지각")
                                            .foregroundColor(Color("myYellow"))
                                            .font(.caption)
                                    }
                                
                                HStack {
                                    Image(systemName: "mappin.and.ellipse")
                                    Text("신촌 베이스볼클럽")        //위치
                                }
                                .padding(.top, 5)
                                
                                HStack {
                                    Image(systemName: "calendar")
                                    Text("3월 10일")              //날짜
                                    
                                }
                                .padding(.vertical, 5)
                                
                                HStack {
                                    Image(systemName: "clock")
                                    Text("오후 3:00 ~ 오후 7:00")  //시간
                                }
                                .padding(.bottom, 5)
                                
                            }
                            
                            Spacer()
                        }
                        .padding(.leading, 20)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color("myLightGray"))
                            .frame(width: .infinity, height:160)
                        
                        HStack {
                            VStack(alignment: .leading){
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 45, height: 25)
                                    .foregroundColor(.white)
                                    .overlay{
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color("myYellow"), lineWidth: 1)
                                        Text("지각")
                                            .foregroundColor(Color("myYellow"))
                                            .font(.caption)
                                    }
                                
                                HStack {
                                    Image(systemName: "mappin.and.ellipse")
                                    Text("신촌 베이스볼클럽")        //위치
                                }
                                .padding(.top, 5)
                                
                                HStack {
                                    Image(systemName: "calendar")
                                    Text("3월 3일")              //날짜
                                    
                                }
                                .padding(.vertical, 5)
                                
                                HStack {
                                    Image(systemName: "clock")
                                    Text("오후 3:00 ~ 오후 7:00")  //시간
                                }
                                .padding(.bottom, 5)
                                
                            }
                            
                            Spacer()
                        }
                        .padding(.leading, 20)
                    }
                    .padding(.horizontal, 40)
                }
            }
        }
    }
}


struct GroupScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        GroupScheduleView()
    }
}
