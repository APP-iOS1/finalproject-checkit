//
//  WebViewModel.swift
//  CheckIt
//
//  Created by 조현호 on 2023/02/06.
//

import Foundation
import Combine

@MainActor
class WebViewModel: ObservableObject {
    var foo = PassthroughSubject<Bool, Never>()
    var bar = PassthroughSubject<Bool, Never>()
    @Published var result: String?
    @Published var jibunAddress: String?
    @Published var isPresentedMapView: Bool = false
}
