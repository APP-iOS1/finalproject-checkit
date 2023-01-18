//
//  GroupMainView.swift
//  CheckIt
//
//  Created by 황예리 on 2023/01/18.
//

import SwiftUI

struct GroupMainView: View {
    @State var isMakingGroup: Bool = false
    @State var isJoiningGroup: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 15) {
                    Spacer()
                    
                    // MARK: - 동아리 개설하기 버튼
                    Button {
                        isMakingGroup.toggle()
                    } label: {
                        // FIXME: - 심볼 수정하기, 지금은 일정을 추가하는 느낌
                        Image(systemName: "note.text.badge.plus")
                            .resizable()
                            .foregroundColor(Color("myYellow"))
                            .frame(width:34,height: 30)
                    }
                    .sheet(isPresented: $isMakingGroup) {
                        MakeGroupModalView()
                            .presentationDetents([.large])
                    }
                    
                    // MARK: - 동아리 참가하기 버튼
                    Button {
                        isJoiningGroup.toggle()
                    } label: {
                        Image(systemName: "iphone.and.arrow.forward")
                            .resizable()
                            .foregroundColor(Color("myYellow"))
                            .frame(width:28,height: 30)
                            .padding(.trailing, 30)
                    }
                    .sheet(isPresented: $isJoiningGroup) {
                        JoinGruopModalView()
                            .presentationDetents([.height(300)])
                    }
                }
                .padding()
                
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(1..<7) { _ in
                            // MARK: - 동아리 리스트
                            NavigationLink(destination: CategoryView()) {
                                HStack {
                                    Spacer()
                                    
                                    Image("chocobi")
                                        .resizable()
                                        .frame(width: 90, height: 90)
                                        .clipShape(Circle())
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("호이의 SSG 응원방")
                                            .font(.title3)
                                        
                                        Text("We are landers\nWe are victory")
                                            .font(.body)
                                    }
                                    
                                    Spacer()
                                }
                                .frame(width: 310, height: 125)
                                .background(Color.myLightGray)
                            .cornerRadius(15)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct GroupMainView_Previews: PreviewProvider {
    static var previews: some View {
        GroupMainView()
    }
}
