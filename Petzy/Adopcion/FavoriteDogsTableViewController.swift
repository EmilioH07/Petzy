//
//  FavoriteDogsTableViewController.swift
//  Petzy
//
//  Created by Emilio Herrera on 08/01/25.
//

import UIKit

class FavoriteDogsTableViewController: UITableViewController {
    
    var favoriteDogIds = Set<String>()
    var dogsForAdoption = [AdoptionAPI]()
    var favoriteDogs: [AdoptionAPI] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 280
        loadFavoriteDogs()  // Filtrar los perros favoritos
        tableView.reloadData()
    }

    func loadFavoriteDogs() {
        // Filtrar los perros favoritos según los IDs almacenados
        favoriteDogs = dogsForAdoption.filter { favoriteDogIds.contains($0.id) }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteDogs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdoptionCell", for: indexPath) as! AdoptionTableViewCell
        let dog = favoriteDogs[indexPath.row]
        cell.configureCell(with: dog, isFavorite: true)
        return cell
    }
    
    @IBAction func favoritecelButtonTapped(_ sender: UIButton) {
        // Obtener la posición de la celda que corresponde al botón presionado
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: buttonPosition) {
            let selectedDog = favoriteDogs[indexPath.row]
            showContactAlert(for: selectedDog)
        } else {
            print("No se pudo determinar la posición del botón")
        }
    }

            
    func showContactAlert(for dog: AdoptionAPI) {
        guard let phoneNumber = dog.cel else {
            print("Número de teléfono no disponible")
            return
        }

        let alertController = UIAlertController(
            title: "Contactar",
            message: "¿Quieres comunicarte con el responsable de esta mascota?",
            preferredStyle: .alert
        )
                
        // Botón de Cancelar
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
                
        // Botón de Contactar
        alertController.addAction(UIAlertAction(title: "Contactar en WhatsApp", style: .default) { _ in
            self.openWhatsApp(with: phoneNumber, dogName: dog.nombre)
        })
                
        // Mostrar la alerta
        present(alertController, animated: true, completion: nil)
    }
            
    func openWhatsApp(with phoneNumber: String, dogName: String?) {
        let baseWhatsAppURL = "https://api.whatsapp.com/send?phone="
        let formattedPhoneNumber = phoneNumber
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")

        // Mensaje predefinido
        let message = "¡Hola! Estoy interesado/a en adoptar a \(dogName ?? "esta mascota"). ¿Podrías brindarme más información, por favor?"
                
        // Codificar el mensaje para incluirlo en el enlace
        guard let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("No se pudo codificar el mensaje")
            return
        }
                
        if let url = URL(string: "\(baseWhatsAppURL)\(formattedPhoneNumber)&text=\(encodedMessage)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("WhatsApp no está instalado en este dispositivo.")
            }
        }
    }
}
