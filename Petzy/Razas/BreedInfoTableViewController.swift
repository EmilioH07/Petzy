//
//  BreedInfoTableViewController.swift
//  Petzy
//
//  Created by Emilio Herrera on 17/12/24.
//

import UIKit
import Network

class BreedInfoTableViewController: UITableViewController {

    var dogBreeds = [DogBreed]()
    
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
        
        tableView.rowHeight = 140
        
        configureNoInternetView()
        
        monitorNetworkConnectivity()
        
        fetchDogBreeds()
    }

    func configureNoInternetView() {
        noInternetView.frame = tableView.bounds
        noInternetView.isHidden = true
        tableView.backgroundView = noInternetView
    }
    
    func monitorNetworkConnectivity() {
        monitor = NWPathMonitor()
        let queue = DispatchQueue.global(qos: .background)
        monitor?.start(queue: queue)
        
        monitor?.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self.noInternetView.isHidden = true
                    self.fetchDogBreeds()
                } else {
                    self.noInternetView.isHidden = false
                    self.dogBreeds = []
                    self.tableView.reloadData()
                }
            }
        }
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
