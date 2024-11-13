//
//  Record.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 11/11/24.
//

import Foundation

struct RecordModel: Codable{
    var id: String = ""
    var userId: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var date: Date = Date()
    
}
