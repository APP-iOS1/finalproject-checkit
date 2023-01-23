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
                    Button {
                        showingPlusSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 30, height: 30)
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
                                .frame(height: 120)
                                .background(Color.myLightGray)
                                .cornerRadius(15)
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
