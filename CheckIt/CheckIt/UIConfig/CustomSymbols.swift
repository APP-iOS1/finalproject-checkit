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
        .frame(width: name == "mapPin" ? 15 : 17, height: name == "mapPin" ? 20 : 18)
        .offset(x: name == "mapPin" ? 1.25 : 0)
}
