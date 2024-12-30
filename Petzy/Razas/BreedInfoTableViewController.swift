//
//  BreedInfoTableViewController.swift
//  Petzy
//
//  Created by Emilio Herrera on 17/12/24.
//

import UIKit

class BreedInfoTableViewController: UITableViewController {
    
    var dogBreeds = [DogBreed]()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.rowHeight = 100
            
            // Obtener las razas de perros
            fetchDogBreeds()
        }
        
        func fetchDogBreeds() {
            guard let url = URL(string: "https://private-e41e00-dogbreed.apiary-mock.com/dogs/dog_list") else {
                print("URL no válida")
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error al obtener los datos: \(error?.localizedDescription ?? "Desconocido")")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let dogList = try decoder.decode([DogBreed].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.dogBreeds = dogList
                        self.tableView.reloadData() // Recargar la tabla después de obtener los datos
                    }
                } catch {
                    print("Error al decodificar los datos: \(error.localizedDescription)")
                }
            }
            
            task.resume()
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dogBreeds.count
        }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DogBreedCell", for: indexPath) as! DogBreedTableViewCell
        let breed = dogBreeds[indexPath.row]
        cell.configureCell(with: breed)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Obtén la raza seleccionada
        let selectedBreed = dogBreeds[indexPath.row]
        
        // Realiza el segue
        performSegue(withIdentifier: "showBreedDetails", sender: selectedBreed)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBreedDetails",
           let breedDetailVC = segue.destination as? BreedDetailViewController,
           let selectedBreed = sender as? DogBreed {
            // Pasa el ID de la raza seleccionada al ViewController de detalles
            breedDetailVC.breedId = selectedBreed.id
        }
    }


}
