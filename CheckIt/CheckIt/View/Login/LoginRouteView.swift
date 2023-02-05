//
//  LoginRouteView.swift
//  CheckIt
//
//  Created by sole on 2023/02/05.
//

import SwiftUI

struct LoginRouteView: View {
    @EnvironmentObject var userStore: UserStore
    var displayView: some View {
        userStore.isPresentedLoginView ? AnyView(RouteSignUpView()) : AnyView(ContentView())
    }
    
    var body: some View {
        displayView
    }
}

struct RouteSignUpView: View {
    @EnvironmentObject var userStore: UserStore
    var displayView: some View {
        userStore.isFirstLogin ? AnyView(SignUpView()) : AnyView(LoginView())
    }
    var body: some View {
        displayView
    }
}

//struct LoginRouteView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginRouteView()
//    }
//}
