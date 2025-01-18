//
//  AdoptionTableViewController.swift
//  Petzy
//
//  Created by Emilio Herrera on 17/12/24.
//

import UIKit
import Network

class AdoptionTableViewController: UITableViewController {

    var dogsForAdoption = [AdoptionAPI]()
    var favoriteDogIds = Set<String>()  // Usar un Set para almacenar los IDs de los perros favoritos
    var favoriteDogs: [String] = []

    let noInternetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.text = "Sin conexión a Internet.\nPor favor, verifica tu conexión."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
        
        return view
    }()

    var monitor: NWPathMonitor?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 280

        configureNoInternetView()

        loadFavorites()

        monitorNetworkConnectivity()
    }

    func monitorNetworkConnectivity() {
        monitor = NWPathMonitor()
        let queue = DispatchQueue.global(qos: .background)
        monitor?.start(queue: queue)
        
        monitor?.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self.noInternetView.isHidden = true
                    self.fetchDogsForAdoption()
                } else {
                    self.noInternetView.isHidden = false
                    self.dogsForAdoption = []
                    self.tableView.reloadData()
                }
            }
        }
    }

    func configureNoInternetView() {
        noInternetView.frame = tableView.bounds
        noInternetView.isHidden = true
        tableView.backgroundView = noInternetView
    }
    
    func fetchDogsForAdoption() {
        guard let url = URL(string: "https://private-2ba523-adoptions.apiary-mock.com/dogs/dog_list") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error al obtener los datos: \(error?.localizedDescription ?? "Desconocido")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let dogList = try decoder.decode([AdoptionAPI].self, from: data)
                
                // Este es el lugar donde recargamos la tabla
                DispatchQueue.main.async {
                    self.dogsForAdoption = dogList
                    
                    // Asegúrate de que reloadData() solo se llame aquí, después de cargar los datos
                    self.tableView.reloadData()
                }
            } catch {
                print("Error al decodificar los datos: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    // Cargar favoritos desde UserDefaults
    func loadFavorites() {
        if let savedFavorites = UserDefaults.standard.array(forKey: "FavoriteDogs") as? [String] {
            favoriteDogIds = Set(savedFavorites)
        }
    }

    func saveFavorites() {
            UserDefaults.standard.set(Array(favoriteDogIds), forKey: "FavoriteDogs")
        }

    @objc func toggleFavorite(_ notification: Notification) {
        if let userInfo = notification.userInfo, let dogId = userInfo["id"] as? String {
            if favoriteDogIds.contains(dogId) {
                favoriteDogIds.remove(dogId)
            } else {
                favoriteDogIds.insert(dogId)
            }
            saveFavorites()
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogsForAdoption.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdoptionCell", for: indexPath) as! AdoptionTableViewCell
        let dog = dogsForAdoption[indexPath.row]
        
        let isFavorite = favoriteDogIds.contains(dog.id)
        cell.configureCell(with: dog, isFavorite: isFavorite)
        
        cell.favoriteAction = {
            if isFavorite {
                self.favoriteDogIds.remove(dog.id)
            } else {
                self.favoriteDogIds.insert(dog.id)
            }
            self.saveFavorites()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }

        // Configurar la acción del botón de contacto
        cell.contactAction = {
            self.showContactAlert(for: dog)
        }
        
        return cell
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFavorites" {
            if let favoriteDogsVC = segue.destination as? FavoriteDogsTableViewController {
                favoriteDogsVC.favoriteDogIds = favoriteDogIds 
                favoriteDogsVC.dogsForAdoption = dogsForAdoption
            }
        }
    }
}
