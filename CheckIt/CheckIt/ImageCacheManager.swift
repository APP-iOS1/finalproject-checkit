//
//  CacheManager.swift
//  CheckIt
//
//  Created by 이학진 on 2023/02/12.
//

import Foundation
import UIKit

enum CacheType {
    case memory
    case disk(URL)
}

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    static let fileManager = FileManager.default
    
    static let cachesDirectory: URL? = ImageCacheManager.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
    
    private init() { }
    
    static func getObject(forKey key: NSString, type: CacheType) -> UIImage? {
        
        switch type {
        case .memory:
            let cachedImage = shared.object(forKey: key)
            return cachedImage
        case .disk(let filePath):
            guard let data = fileManager.contents(atPath: filePath.path) else {
                return nil
            }
            return UIImage(data: data)
        }
    }
    
    static func setObject(image: UIImage, forKey key: NSString, type: CacheType) {
        switch type {
        case .memory:
            shared.setObject(image, forKey: key)
        case .disk(let filePath):
            fileManager.createFile(atPath: filePath.path, contents: image.pngData())
        }
    }
}
