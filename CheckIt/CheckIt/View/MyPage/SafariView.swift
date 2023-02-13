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
            return URL(string: "https://oval-cucumber-62e.notion.site/f596a8cc8d2d4d71aecefd39a670bf2b")!
            
        case .QA:
            return URL(string: "https://oval-cucumber-62e.notion.site/74df9a9658e149efa132df132d1174d5")!
        
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
