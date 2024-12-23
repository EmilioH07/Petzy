//
//  Recordatorio.swift
//  Petzy
//
//  Created by Emilio Herrera on 19/12/24.
//

import Foundation

class Recordatorio: Codable {
    var tipo: String
    var fecha: String
    var hora: String
    var lugar: String
    var notas: String
    
    init(tipo: String, fecha: String, hora: String, lugar: String, notas: String) {
        self.tipo = tipo
        self.fecha = fecha
        self.hora = hora
        self.lugar = lugar
        self.notas = notas
    }
}

