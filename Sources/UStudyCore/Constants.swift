//
//  Constants.swift
//  UStudy
//
//  Created by Jann Schafranek on 24.01.19.
//  Copyright © 2019 Jann Thomas. All rights reserved.
//

import Foundation
import SchafKit

public struct Constants {
    struct Script {
        static let fetchMensa = "fetchMensa"
        static let fetchGrades = "fetchGrades"
    }
    
    static let bundle = Bundle(identifier: "com.JannThomas.UStudy")!
    static let coreBundle = Bundle.module
    
    static let extensionsFileName = "extensions.js"
    static let modulesURL = coreBundle.url(forResource: "modules", withExtension: "js")!
    static let mainScriptName = "main.js"
    public static let mainPayloadName = "main.json"
    
    public static let authors: [Author] = [
        Author(name: "Jann Schafranek", imageUrl: "https://scontent-frt3-2.cdninstagram.com/v/t51.2885-15/e35/s240x240/47458592_2175019372766943_5736930788124806816_n.jpg?_nc_ht=scontent-frt3-2.cdninstagram.com&_nc_cat=103&_nc_ohc=lcu51XonvCUAX9G6yEa&oh=6223c288bd211309cc45af12ccd3f35f&oe=5EB8415B", contactOptions: [
            Author.ContactOption(serviceName: "Website", serviceImageUrl: "link", url: "https://jannthomas.com"),
            Author.ContactOption(serviceName: "Mail", serviceImageUrl: "envelope.fill", url: "mailto:me@jannthomas.com"),
            Author.ContactOption(serviceName: "LinkedIn", serviceImageUrl: "linkedin", url: "https://www.linkedin.com/in/jann-schafranek-4b559717a/"),
            Author.ContactOption(serviceName: "GitHub", serviceImageUrl: "github", url: "https://github.com/JannThomas"),
            Author.ContactOption(serviceName: "AppStore", serviceImageUrl: "appstore", url: "https://itunes.apple.com/de/developer/jann-schafranek/id1171358253"),
            Author.ContactOption(serviceName: "PayPal", serviceImageUrl: "paypal", url: "https://paypal.me/jannthomas"),
            Author.ContactOption(serviceName: "Snapchat", serviceImageUrl: "snapchat", url: "https://www.snapchat.com/add/jann.schafranek"),
            Author.ContactOption(serviceName: "Instagram", serviceImageUrl: "instagram", url: "https://www.instagram.com/jschafranek/")
        ])
    ]
}
