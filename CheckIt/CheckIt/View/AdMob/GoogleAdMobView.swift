//
//  GoogleAdMobView.swift
//  CheckIt
//
//  Created by 이학진 on 2023/02/14.
//

import SwiftUI
import UIKit
import GoogleMobileAds

struct GoogleAdMobView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        
        let bannerSize = GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.screenWidth)
        let banner = GADBannerView(adSize: bannerSize)
        
        banner.rootViewController = viewController
        viewController.view.addSubview(banner)
        viewController.view.frame = CGRect(origin: .zero, size: bannerSize.size)
        
        banner.adUnitID = Constants.adID
        banner.load(GADRequest())
        
        return viewController
    }
    
    func updateUIViewController(_ viewController: UIViewController, context: Context) {

    }
}

private enum Constants {
    static let adID: String = "ca-app-pub-8771983832756290/5922293367"
    static let testAdID: String = "ca-app-pub-3940256099942544/2934735716"
}
