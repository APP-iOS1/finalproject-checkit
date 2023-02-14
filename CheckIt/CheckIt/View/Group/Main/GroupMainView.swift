//
//  GroupMainView.swift
//  CheckIt
//
//  Created by 황예리 on 2023/01/18.
//

import SwiftUI
import AlertToast
import GoogleMobileAds

struct GroupMainView: View {
    @State var showingPlusSheet: Bool = false
    @State var isMakingGroup: Bool = false
    @State var isJoiningGroup: Bool = false
    // FIXME: - 토스트 관련 열거형으로 리팩토링 필요
    @State var showToast: Bool = false
    @State var toastMessage: String = ""
    
    @State private var toastObj = ToastMessage(message: "", type: .failed)
    
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
                                NavigationLink(destination: CategoryView(showToast: $showToast, toastMessage: $toastMessage, toastObj: $toastObj, group: group)) {
                                    GroupMainDetailView(group: group, groupImage: groupStores.groupImage[group.id] ?? UIImage())
                                        .frame(height: 130)
                                        .background(Color.myLightGray)
                                        .cornerRadius(18)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 18)
                                                .stroke(Color.myGray)
                                                .frame(height: 130)
//                                                
                                        }
                                }
                            }
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 30)
                    }
                    .refreshable {
                        guard let user = userStores.user else { return }
                        groupStores.groups.removeAll()
                        Task {
                            await groupStores.fetchGroups(user)
                        }
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
                            .foregroundColor(.primary)
                            .padding(.trailing, 20)
                    }
                    .sheet(isPresented: $showingPlusSheet) {
                        MainPlusSheetView(showToast: $showToast, toastObj: $toastObj)
                            .environment(\.presentations, presentations + [$showingPlusSheet])
                            .presentationDetents([.height(415)])
                    }
                }
            }
            
            
            .toast(isPresenting: $showToast){
                switch toastObj.type {
                case .competion:
                    return AlertToast(displayMode: .banner(.slide), type: .complete(.myGreen), title: toastObj.message)
                case .failed:
                    return AlertToast(displayMode: .banner(.slide), type: .error(.red), title: toastObj.message)
                }
                
//                AlertToast(displayMode: to, type: <#T##AlertToast.AlertType#>)
//                AlertToast(displayMode: .banner(.slide), type: .regular, title: toastMessage)
            }

        }
        
        .onAppear {
            //scheduleStore.scheduleList = []
            
            guard let user = userStores.user else { return }
            let newGroup = Group.sortedGroup(groupStores.groups, userId: user.id)
            groupStores.groups = newGroup
            
//            Task {
//                await groupStores.fetchGroups(user)
//            }
            
            userStores.fetchUserDictionaryList()
        }
    }
    
    @ViewBuilder func admob() -> some View {
        // admob
        GoogleAdMobView()
            .frame(width: UIScreen.main.bounds.width, height: GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width).size.height)
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
