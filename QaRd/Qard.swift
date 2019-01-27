//
//  Qard.swift
//  QaRd
//
//  Created by Kevin Wong on 2019-01-26.
//  Copyright © 2019 Christina Zhang. All rights reserved.
//

import Foundation
import UIKit

class Link: Equatable {
    static func == (lhs: Link, rhs: Link) -> Bool {
        return (lhs.message == rhs.message && lhs.URL == rhs.URL && lhs.username == rhs.username)
    }
    
    var URL: String?
    var username: String?
    var message: String?
    
    convenience init(url: String, username:String, message:String) {
        self.init()
        self.URL = url
        self.username = username
        self.message = message
    }
}


class Qard {
    var id: String?
    var gradient: [CGColor] = []
    //    var color: UIColor?
    var isPrivate: Bool?
    
    var title: String?
    var subtitle: String?
    
    var links: [Link] = []
    
    init(id: String?,
         gradient: [CGColor],
         //        color: UIColor?,
        isPrivate: Bool?,
        title: String?,
        subtitle: String?,
        links: [Link]) {
        self.id = id
        //        self.color = color
        self.gradient = gradient
        self.title = title
        self.subtitle = subtitle
        self.links = links
    }
    
    convenience init() {
        self.init(id: nil, gradient: [], isPrivate: nil, title: nil, subtitle: nil, links: [])
    }
    
    func toJSON() -> [String: Any] {
        
        if let id = self.id, let isPrivate = self.isPrivate, let title = self.title, let subtitle = self.subtitle {
            
            var linkObject: [[String: Any]] = []
            for link in self.links {
                linkObject.append(["URL": link.URL, "username": link.username, "message": link.message])
                
            }
            
            let jsonObject: [String: Any] = [
                "id": id,
                "isPrivate": isPrivate,
                "title": title,
                "subtitle": subtitle,
                "links": linkObject
            ]
            
            JSONSerialization.isValidJSONObject(jsonObject)
            
            return jsonObject
        }
        
        return [:]
    }
}


