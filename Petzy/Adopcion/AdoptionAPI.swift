//
//  AdoptionAPI.swift
//  Petzy
//
//  Created by Emilio Herrera on 17/12/24.
//

import Foundation

struct AdoptionAPI: Decodable {
    let id: String
    let image: String?
    let nombre: String?
    let ubicacion: String?
    let edad: String?
}
