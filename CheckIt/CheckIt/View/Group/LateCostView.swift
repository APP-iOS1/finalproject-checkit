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

struct LateCostView: View {
    @State private var tempCostData: [LateCost] = [
        LateCost(name: "허혜민", attendance: "출석", cost: 0, isChecked: true),
        LateCost(name: "윤예린", attendance: "출석", cost: 0, isChecked: true),
        LateCost(name: "류창휘", attendance: "결석", cost: 5000, isChecked: true),
        LateCost(name: "황예리", attendance: "출석", cost: 0, isChecked: true),
        LateCost(name: "조현호", attendance: "공결", cost: 0, isChecked: true),
        LateCost(name: "이학진", attendance: "지각", cost: 500, isChecked: true),
        LateCost(name: "허혜민", attendance: "출석", cost: 0, isChecked: true),
        LateCost(name: "윤예린", attendance: "출석", cost: 0, isChecked: true),
        LateCost(name: "류창휘", attendance: "결석", cost: 5000, isChecked: true),
        LateCost(name: "황예리", attendance: "출석", cost: 0, isChecked: true),
        LateCost(name: "조현호", attendance: "공결", cost: 0, isChecked: true),
        LateCost(name: "이학진", attendance: "지각", cost: 500, isChecked: true)
    ]
    
    var totalCost: Int {
        tempCostData
            .filter{ $0.isChecked }
            .map{ $0.cost }
            .reduce(0, +)
    }
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .listRowSeparatorLeading) {
                    Spacer()
                    HStack {
                        Group {
                            Text("출석")
                            Text("11")   //출석 횟수
                                .foregroundColor(.myGreen)
                                .bold()
                        }
                        
                        Divider().frame(height:20)
                        
                        Text("지각")
                        Text("1")   //지각 횟수
                            .foregroundColor(.myOrange)
                            .bold()
                        
                        Divider().frame(height:20)
                        
                        Text("결석")
                        Text("3")   //결석 횟수
                            .foregroundColor(.myRed)
                            .bold()
                        
                        Divider().frame(height:20)
                        
                        Text("공결")
                        Text("1")   //공결 횟수
                            .foregroundColor(.myRed)
                            .bold()
                    }
                    Divider()
                    Spacer()
                    
                    ForEach($tempCostData) { data in
                        LateCostCellView(data: data)
                            .frame(height: 50)
                    }
                    //Spacer()
                }
                .navigationTitle("2023년 1월 20일")
            }
            
            HStack {
                Spacer()
                Text("지각비 합계: \(totalCost)")
                    .font(.title2)
                    .padding([.top, .trailing])
            }
        }
    }
}

struct LateCostView_Previews: PreviewProvider {
    static var previews: some View {
        LateCostView()
    }
}
