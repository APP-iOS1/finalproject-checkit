//
//  GroupMainView.swift
//  CheckIt
//
//  Created by 황예리 on 2023/01/18.
//

import SwiftUI

struct GroupMainView: View {
    @State var showingPlusSheet: Bool = false
    @State var isMakingGroup: Bool = false
    @State var isJoiningGroup: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .trailing) {
                HStack {
                    // MARK: - 동아리 메인뷰 플러스 버튼 (동아리 개설하기, 동아리 참가하기)
                    Button {
                        showingPlusSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .sheet(isPresented: $showingPlusSheet) {
                        MainPlusSheetView()
                            .presentationDetents([.height(420)])
                    }
                }
                .padding()
                
                
                ScrollView {
                    VStack(spacing: 20) {
                        // FIXME: - 동아리 리스트 데이터 연결하기
                        ForEach(1..<7) { _ in
                            // MARK: - 동아리 리스트
                            NavigationLink(destination: CategoryView()) {
                                HStack {
                                    Spacer()
                                    
                                    ZStack(alignment: .topLeading) {
                                        // MARK: - 동아리 이미지
                                        Image("chocobi")
                                            .resizable()
                                            .frame(width: 90, height: 90)
                                            .clipShape(Circle())
                                        
                                        ZStack {
                                            // MARK: - 방장, 운영진 여부
                                            Circle()
                                                .fill(.white)
                                                .frame(width: 25, height: 25)
                                            
                                            Image(systemName: "crown.fill")
                                                .resizable()
                                                .frame(width: 20, height: 15)
                                                .foregroundColor(Color.myGreen)
                                            // FIXME: - 방장은 Color.myGreen, 운영진은 Color.myOrange로 바껴야함
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        // MARK: - 동아리 이름
                                        Text("호이의 SSG 응원방")
                                            .font(.system(size: 16, weight: .semibold))
                                        
                                        // MARK: - 동아리 상세 내용
                                        Text("We are landers\nWe are victory")
                                            .font(.system(size: 13, weight: .regular))
                                    }
                                    
                                    Spacer()
                                }
                                .frame(height: 120)
                                .background(Color.myLightGray)
                                .cornerRadius(18)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 40)
        }
    }
}

struct GroupMainView_Previews: PreviewProvider {
    static var previews: some View {
        GroupMainView()
    }
}
