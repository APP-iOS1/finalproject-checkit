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
    
    @EnvironmentObject var groupStores: GroupStore
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    // MARK: - 동아리 메인뷰 플러스 버튼 (동아리 개설하기, 동아리 참가하기)
                    Spacer()
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
                        
                        ForEach(groupStores.groups) { group in
                            // MARK: - 동아리 리스트
                            NavigationLink(destination: CategoryView()) {
                                GroupMainDetailView(group: group)
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
        .onAppear {
            Task {
                await groupStores.fetchGroups("Dpcvu3OOAUuq3ccDhBcW")
                print("동아리들: \(groupStores.groups)")
            }
        }
    }
}

struct GroupMainView_Previews: PreviewProvider {
    static var previews: some View {
        GroupMainView()
            .environmentObject(GroupStore())
    }
}
