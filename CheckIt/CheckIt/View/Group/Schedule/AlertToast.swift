//
//  AlertToast.swift
//  CheckIt
//
//  Created by 황예리 on 2023/02/03.
//

//import AlertToast
//import SwiftUI
//
//struct AlertToast: View {
//    @State private var showAlert = false
//
//    var body: some View {
//        VStack{
//
//            Button("Show Toast"){
//                showAlert.toggle()
//            }
//        }
////        .toast(isPresenting: $showToast){
////
////            // `.alert` is the default displayMode
////            AlertToast(type: .regular, title: "Message Sent!")
////
////            //Choose .hud to toast alert from the top of the screen
////            //AlertToast(displayMode: .hud, type: .regular, title: "Message Sent!")
////
////            //Choose .banner to slide/pop alert from the bottom of the screen
////            //AlertToast(displayMode: .banner(.slide), type: .regular, title: "Message Sent!")
////        }
//        .toast(isPresenting: $showAlert, duration: 2, tapToDismiss: true, alert: {
//           //AlertToast goes here
//            AlertToast(type: .regular, title: Optional(String), subTitle: Optional(String))
//        }, onTap: {
//           //onTap would call either if `tapToDismis` is true/false
//           //If tapToDismiss is true, onTap would call and then dismis the alert
//        }, completion: {
//           //Completion block after dismiss
//        })
//    }
//}
//
//struct AlertToast_Previews: PreviewProvider {
//    static var previews: some View {
//        AlertToast()
//    }
//}
