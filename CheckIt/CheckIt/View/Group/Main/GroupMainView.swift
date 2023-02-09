//
//  GroupMainView.swift
//  CheckIt
//
//  Created by 황예리 on 2023/01/18.
//

import SwiftUI
import AlertToast

struct GroupMainView: View {
    @State var showingPlusSheet: Bool = false
    @State var isMakingGroup: Bool = false
    @State var isJoiningGroup: Bool = false
    // FIXME: - 토스트 관련 열거형으로 리팩토링 필요
    @State var showToast: Bool = false
    @State var toastMessage: String = ""
    
    @EnvironmentObject var groupStores: GroupStore
    @EnvironmentObject var scheduleStore: ScheduleStore
    @EnvironmentObject var userStores: UserStore
    @Environment(\.presentations) private var presentations
    
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
                                NavigationLink(destination: CategoryView(showToast: $showToast, toastMessage: $toastMessage, group: group)) {
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
            .onAppear {
                scheduleStore.scheduleList = []
                guard let user = userStores.user else { return }
                let hostGroups = groupStores.groups.filter{ $0.hostID == user.id }
                let notHostGroups = groupStores.groups.filter{ $0.hostID != user.id }
                groupStores.groups = hostGroups + notHostGroups
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
                        MainPlusSheetView(showToast: $showToast, toastMessage: $toastMessage)
                            .environment(\.presentations, presentations + [$showingPlusSheet])
                            .presentationDetents([.height(415)])
                    }
                }
            }
            .toast(isPresenting: $showToast){
                AlertToast(displayMode: .banner(.slide), type: .regular, title: toastMessage)
            }

        }
        .padding()
        
        .onAppear {
            userStores.fetchUserDictionaryList()
        }
    }
}

struct PresentationKey: EnvironmentKey {
    static let defaultValue: [Binding<Bool>] = []
}

extension EnvironmentValues {
    var presentations: [Binding<Bool>] {
        get { return self[PresentationKey] }
        set { self[PresentationKey] = newValue }
    }
}
    
    struct GroupMainView_Previews: PreviewProvider {
        @State var showToast: Bool
        @State var toastMessage: String
        
        static var previews: some View {
            GroupMainView()
                .environmentObject(GroupStore())
        }
    }
