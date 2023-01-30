//
//  AttendancePickerView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/01/20.
//

import SwiftUI

struct AttendancePickerView: View {
    @Binding var selectedTap: AttendanceCategory
    
    var body: some View {
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
    }
}

struct AttendancePickerView_Previews: PreviewProvider {
    @State static var selectedTap = AttendanceCategory.attendanced
    static var previews: some View {
        AttendancePickerView(selectedTap: $selectedTap)
    }
}
