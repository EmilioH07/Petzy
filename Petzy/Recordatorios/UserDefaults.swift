//
//  UserDefaults.swift
//  Petzy
//
//  Created by Emilio Herrera on 20/12/24.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let recordatorios = "recordatorios"  // Clave para acceder a los recordatorios
    }

    // Función para guardar recordatorios
    func saveRecordatorios(_ recordatorios: [Recordatorio]) {
        let encoder = JSONEncoder()  // Utilizamos JSONEncoder para convertir el arreglo de recordatorios a un formato de datos
        if let encoded = try? encoder.encode(recordatorios) {
            set(encoded, forKey: Keys.recordatorios)  // Guardamos los datos en UserDefaults usando la clave
        }
    }

    // Función para cargar recordatorios
    func loadRecordatorios() -> [Recordatorio]? {
        if let savedData = data(forKey: Keys.recordatorios) {  // Obtenemos los datos guardados con la clave
            let decoder = JSONDecoder()  // Usamos JSONDecoder para convertir los datos de vuelta a un arreglo de Recordatorios
            if let loadedRecordatorios = try? decoder.decode([Recordatorio].self, from: savedData) {
                return loadedRecordatorios  // Devolvemos el arreglo de recordatorios
            }
        }
        return nil  // Si no se encontraron datos, devolvemos nil
    }
}

