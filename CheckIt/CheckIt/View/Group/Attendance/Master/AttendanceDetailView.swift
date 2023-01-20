//
//  LateCostView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/18.
//

import SwiftUI

struct LateCost: Identifiable {
    var id = UUID().uuidString
    let name: String
    var attendance: String
    let cost: Int
    var isChecked: Bool
}

struct AttendanceDetailView: View {
    @State private var selectedTap: AttendanceCategory = .attendanced
    
//    var totalCost: Int {
//        tempCostData
//            .filter{ $0.isChecked }
//            .map{ $0.cost }
//            .reduce(0, +)
//    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(AttendanceCategory.allCases, id: \.self) { tap in
                    VStack {
                        Button {
                            selectedTap = tap
                        } label: {
                            Text("\(tap.rawValue)")
                                .foregroundColor(selectedTap == tap ? .black : .gray)
                        }
                        
                        if selectedTap == tap {
                            Capsule()
                                .foregroundColor(.black)
                                .frame(height: 2)
                        } else {
                            Capsule()
                                .foregroundColor(.white)
                                .frame(height: 2)
                        }
                    }
                }
            }
            .padding()
            .padding(.top, UIScreen.main.bounds.height / 30)
            
            AttendanceCategoryView(selection: selectedTap)
            
            Spacer()
        }
        .navigationTitle("2023년 1월 20일 출석부")
    }
}

struct LateCostView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceDetailView()
    }
}
