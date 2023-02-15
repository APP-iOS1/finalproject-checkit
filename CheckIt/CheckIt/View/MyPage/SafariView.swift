//
//  SafariView.swift
//  CheckIt
//
//  Created by sole on 2023/02/13.
//
import UIKit
import SafariServices
import SwiftUI

enum SafariMode: String {
    case term
    case QA
}

struct SafariView:  UIViewControllerRepresentable {
    var mode: SafariMode
    var url: URL {
        switch mode {
        case .term:
            return URL(string: "https://check-it.notion.site/cddd689f39aa4dd38bebc3e8d9b6f3cd")!
            
        case .QA:
            return URL(string: "https://check-it.notion.site/cddd689f39aa4dd38bebc3e8d9b6f3cd")!
        
        default:
            return URL(string: "https://www.google.co.kr/")!
        }
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        if ["http", "https"].contains(url.scheme?.lowercased() ?? "") {
            return SFSafariViewController(url: url)
        }
        return SFSafariViewController(url: URL(string: "https://www.google.co.kr/")!)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
    }
}
