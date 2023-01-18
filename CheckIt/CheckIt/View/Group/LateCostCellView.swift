//
//  LateCostCellView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/18.
//

import SwiftUI

struct LateCostCellView: View {
    @Binding var data: LateCost
    
    var attendanceColor: Color {
        switch data.attendance {
        case "출석":
            return Color.myGreen
        case "지각":
            return Color.myYellow
        case "결석":
            return Color.myRed
        case "공결":
            return Color.myBlack
        default:
            return Color.myBlack
        }
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            Text(data.name)
            
            Spacer()
            
            Menu {
                Button {
                    data.attendance = "출석"
                } label: {
                    Text("출석")
                }
                Button {
                    data.attendance = "지각"
                } label: {
                    Text("지각")
                }
                Button {
                    data.attendance = "결석"
                } label: {
                    Text("결석")
                }
                Button {
                    data.attendance = "공결"
                } label: {
                    Text("공결")
                }

            } label: {
                Text(data.attendance)
                    .foregroundColor(attendanceColor)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 3)
                
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(attendanceColor, lineWidth: 1)
                    }
            }
            
            Spacer()
            
            Text(data.cost == 0 ? "-" : "\(data.cost)")
                .frame(width: 60)
            
            Spacer()
            
            Button(action: {
                data.isChecked.toggle()
            }, label: {
                ZStack {
                    Image(systemName: "rectangle")
                    
                    Image(systemName: "checkmark")
                        .opacity(data.isChecked ? 1 : 0)
                }
            })
            .fontWeight(.none)
            .foregroundColor(Color.myBlack)
            
            Spacer()
        }
        .bold()
        .frame(minWidth: UIScreen.main.bounds.width - 20)
    }
}

struct LateCostCellView_Previews: PreviewProvider {
    static var previews: some View {
        LateCostView()
        //        LateCostCellView(data: LateCost(name: "이학진", attendance: "출석", cost: 0, isChecked: false))
    }
}
