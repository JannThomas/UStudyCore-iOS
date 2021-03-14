//
//  Grade.swift
//  UStudyCore
//
//  Created by Jann Schafranek on 18.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import Foundation

public struct Grade: Codable {
    public enum Status: String, Codable {
        case passed, failed, unknown
    }
    public struct GradeOverviewItem: Codable {
        public let grade: String
        public let quantity: Int
    }
    
    public let id: String
    public let name: String
    
    public let status: Status
    public let grade: String?
    public let credits: Int?
    
    public let date: Date?
    public let numberOfTry: Int?
    
    public let overviewOfGrades: [GradeOverviewItem]
    public let averageGrade: String
}
