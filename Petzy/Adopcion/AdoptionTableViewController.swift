//
//  AdoptionTableViewController.swift
//  Petzy
//
//  Created by Emilio Herrera on 17/12/24.
//

import UIKit

class AdoptionTableViewController: UITableViewController {

    var dogsForAdoption = [AdoptionAPI]()
    var favoriteDogIds = Set<String>()  // Usar un Set para almacenar los IDs de los perros favoritos
    var favoriteDogs: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configura la altura dinámica de las celdas
        tableView.rowHeight = 280

        // Cargar favoritos desde UserDefaults
        loadFavorites()

        // Observar notificaciones para cambios en favoritos
        NotificationCenter.default.addObserver(self, selector: #selector(toggleFavorite(_:)), name: NSNotification.Name("ToggleFavorite"), object: nil)

        fetchDogsForAdoption()
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
        
        // Verificar si el perro es favorito
        let isFavorite = favoriteDogIds.contains(dog.id)
        
        cell.configureCell(with: dog, isFavorite: isFavorite)
        
        // Configurar la acción del botón de favorito
        cell.favoriteAction = {
            if isFavorite {
                // Si ya es favorito, eliminarlo
                self.favoriteDogIds.remove(dog.id)
            } else {
                // Si no es favorito, agregarlo
                self.favoriteDogIds.insert(dog.id)
            }
            
            // Guardar la lista actualizada en UserDefaults
            self.saveFavorites()
            
            // Recargar la celda actual para reflejar el cambio
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showFavorites" {
                if let favoriteDogsVC = segue.destination as? FavoriteDogsTableViewController {
                    favoriteDogsVC.favoriteDogIds = favoriteDogIds // Pasar los IDs favoritos
                    favoriteDogsVC.dogsForAdoption = dogsForAdoption // Pasar los perros para que se puedan filtrar
                }
            }
        }
}
