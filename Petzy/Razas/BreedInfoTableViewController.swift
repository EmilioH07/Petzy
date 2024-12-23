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
        let nib = UINib(nibName: "DogBreedTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DogBreedCell")
        
        fetchDogBreeds()
    }
    
    func fetchDogBreeds() {
        guard let url = URL(string: "https://private-e41e00-dogbreed.apiary-mock.com/dogs/dog_list") else { return }
        
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
                    self.tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DogBreedCell", for: indexPath) as! DogBreedTableViewCell
        let breed = dogBreeds[indexPath.row]
        cell.configureCell(with: breed)
        return cell
    }

    // MARK: - Navegar al detalle de la raza
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Obtén el objeto de la raza seleccionada
        let selectedBreed = dogBreeds[indexPath.row]
        
        // Realiza el segue hacia el detalle
        performSegue(withIdentifier: "showBreedDetails", sender: selectedBreed)
    }

    // MARK: - Preparar para el segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBreedDetails" {
            if let breedDetailVC = segue.destination as? BreedDetailViewController,
               let selectedBreed = sender as? DogBreed {
                breedDetailVC.breedId = selectedBreed.id // Envía el ID de la raza
            }
        }
    }
}
