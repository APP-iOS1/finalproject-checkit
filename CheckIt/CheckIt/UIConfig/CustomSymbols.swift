//
//  Symbols.swift
//  CheckIt
//
//  Created by sole on 2023/01/21.
//

import SwiftUI

func customSymbols(name: String) -> some View {
    Image("\(name)")
        .resizable()
        .frame(width: 15, height: 16.48)
}
