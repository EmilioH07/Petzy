//
//  AdoptionTableViewController.swift
//  Petzy
//
//  Created by Emilio Herrera on 17/12/24.
//

import UIKit

class AdoptionTableViewController: UITableViewController {

    var dogsForAdoption = [AdoptionAPI]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configura la altura dinámica de las celdas
        tableView.rowHeight = 120
        
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

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogsForAdoption.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdoptionCell", for: indexPath) as! AdoptionTableViewCell
        let dog = dogsForAdoption[indexPath.row]
        cell.configureCell(with: dog)
        return cell
    }
}




    /*// MARK: - Navegar al detalle de la raza
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
    }*/

