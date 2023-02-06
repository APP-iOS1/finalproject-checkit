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
    @EnvironmentObject var userStores: UserStore
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                if groupStores.groups.isEmpty {
                    Spacer()
                    GroupEmptyView()
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            
                            // FIXME: - 동아리 리스트 데이터 연결하기
                            
                            ForEach(groupStores.groups) { group in
                                // MARK: - 동아리 리스트
                                NavigationLink(destination: CategoryView(group: group)) {
                                    GroupMainDetailView(group: group, groupImage: groupStores.groupImage[group.id] ?? UIImage())
                                        .frame(height: 130)
                                        .background(Color.myLightGray)
                                        .cornerRadius(18)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("나의 동아리")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // MARK: - Plus Button (동아리 개설하기, 동아리 참가하기)
                    Button {
                        showingPlusSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                    }
                    .sheet(isPresented: $showingPlusSheet) {
                        MainPlusSheetView()
                            .presentationDetents([.height(420)])
                    }
                }
            }
            .onAppear {
                Task {
                        await groupStores.fetchGroups(userStores.user!)
                    print("동아리들: \(groupStores.groups)")
                }
            }

        }
        .padding()
    }
}
    
    struct GroupMainView_Previews: PreviewProvider {
        static var previews: some View {
            GroupMainView()
                .environmentObject(GroupStore())
        }
    }
