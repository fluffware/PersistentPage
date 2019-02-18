//
//  PageSettings.swift
//  SwiftToy
//
//  Created by Simon on 2019-02-15.
//  Copyright © 2019 Elektro-Kapsel AB. All rights reserved.
//

import WebKit

class PageSettings :NSObject, NSCoding
{
    
    
    // MARK: Properties
    var url: URL
    var timeout: Int // In seconds
    
    init(url: URL, timeout: Int) {
        self.url = url
        self.timeout = timeout
    }
    
    
    func encode(with coder: NSCoder) {
        coder.encode(url, forKey: PropertyKey.URL)
        coder.encode(timeout,forKey: PropertyKey.timeout)
    }
    
    // MARK: NSCoder
    required convenience init?(coder aDecoder: NSCoder) {
        //
        guard let url = aDecoder.decodeObject(forKey:PropertyKey.URL) as? URL else {
            return nil
        }
        
        let timeout = aDecoder.decodeInteger(forKey:PropertyKey.timeout)
        self.init(url: url, timeout: timeout)
        
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("settings")
}

struct PropertyKey {
    static let URL = "URL"
    static let timeout = "timeout"
}
