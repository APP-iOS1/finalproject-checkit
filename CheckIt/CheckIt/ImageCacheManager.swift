//
//  CacheManager.swift
//  CheckIt
//
//  Created by 이학진 on 2023/02/12.
//

import Foundation
import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    static let fileManager = FileManager.default
    
    private let memoryWarningNotification = UIApplication.didReceiveMemoryWarningNotification
    
    private init() { }
    
    static func getObject(forKey key: NSString) -> UIImage? {
        let cachedImage = shared.object(forKey: key)
        return cachedImage
    }
    
    static func setObject(image: UIImage, forKey key: NSString) {
        shared.setObject(image, forKey: key)
    }
}
