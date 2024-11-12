//
//  Record.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 11/11/24.
//

import Foundation

struct RecordModel: Identifiable, Decodable {
    var id: String
    var userId: String
    var latitude: Double
    var longitude: Double
    var date: Date
    
}
