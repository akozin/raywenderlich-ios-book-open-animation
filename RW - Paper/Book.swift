//
//  Book.swift
//  RW - Paper
//
//  Created by Attila on 2014. 12. 15..
//  Copyright (c) 2014. -. All rights reserved.
//

import UIKit

class Book {

    convenience init (dict: NSDictionary) {
        self.init()
        self.dict = dict
    }
    
    var dict: NSDictionary?
    
    func coverImage () -> UIImage? {
        if let cover = dict?["cover"] as? String {
            return UIImage(named: cover)
        }
        return nil
    }
    
    func pageImage (index: Int) -> UIImage? {
        if let pages = dict?["pages"] as? NSArray {
            if let page = pages[index] as? String {
                return UIImage(named: page)
            }
        }
        return nil
    }
    
    func numberOfPages () -> Int {
        if let pages = dict?["pages"] as? NSArray {
            return pages.count
        }
        return 0
    }
    
}
