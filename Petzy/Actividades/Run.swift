//
//  Run.swift
//  Petzy
//
//  Created by Emilio Herrera on 30/12/24.
//

import Foundation

struct Lugar: Codable {
    let id: String
    let image: String
    let title: String
}

struct LugarDetalle: Codable {
    let title: String
    let latitud: String
    let longitud: String
}

struct Plaza: Codable {
    let id: String
    let image: String
    let title: String
}

struct PlazaDetalle: Codable {
    let title: String
    let latitud: String
    let longitud: String
}

