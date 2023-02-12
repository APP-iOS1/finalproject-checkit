//
//  ColorExtension.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI

extension Color {
    static var myGreen = Color("myGreen")
    static var myOrange = Color("myOrange")
    static var myRed = Color("myRed")
    static var myGray = Color("myGray")
    static var myLightGray = Color("myLightGray")
    static var myBlack = Color("myBlack")
    static var gradientGreen = Color("gradientGreen")
    static var gradientLightGreen = Color("gradientLightGreen")
    static var qrCodeGreen = Color(hex: 0x82C18D, alpha: 1)
    static var qrCodeYellow = Color(hex: 0xF9DE83, alpha: 1)
    static var toastAlertGray = Color(hex: 0xD9D9D9, alpha: 0.6)
    
    
    init(hex: UInt, alpha: Double = 1) {
            self.init(
                .sRGB,
                red: Double((hex >> 16) & 0xff) / 255,
                green: Double((hex >> 08) & 0xff) / 255,
                blue: Double((hex >> 00) & 0xff) / 255,
                opacity: alpha
            )
        }
}


