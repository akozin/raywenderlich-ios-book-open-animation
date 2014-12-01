//
//  BookStore.swift
//  RW - Paper
//
//  Created by Attila on 2014. 12. 15..
//  Copyright (c) 2014. -. All rights reserved.
//

import UIKit

class BookStore {

    class var sharedInstance : BookStore {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : BookStore? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = BookStore()
        }
        
        return Static.instance!
    }
    
    func loadBooks(plist: String) -> [Book] {
        var books: [Book] = []
        
        if let path = NSBundle.mainBundle().pathForResource(plist, ofType: "plist") {
            if let array = NSArray(contentsOfFile: path) {
                for dict in array as [NSDictionary] {
                    let book = Book(dict: dict)
                    books += [book]
                }
            }
        }
        
        return books
    }
    
}
