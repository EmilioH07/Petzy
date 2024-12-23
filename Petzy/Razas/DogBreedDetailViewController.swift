//
//  DogBreedDetailViewController.swift
//  Petzy
//
//  Created by Emilio Herrera on 17/12/24.
//

import UIKit

class BreedDetailViewController: UIViewController {

    @IBOutlet weak var breedImageView: UIImageView!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var lifeExpectancyLabel: UILabel!
    @IBOutlet weak var coatTypeLabel: UILabel!
    @IBOutlet weak var temperamentLabel: UILabel!
    @IBOutlet weak var exerciseNeedLabel: UILabel!

    var breedId: String? // ID de la raza seleccionada
            
        override func viewDidLoad() {
            super.viewDidLoad()
            if let breedId = breedId {
                fetchBreedDetails(for: breedId)
            }
        }
        
        func fetchBreedDetails(for breedId: String) {
            guard let url = URL(string: "https://private-e41e00-dogbreed.apiary-mock.com/dogs/dog_list/\(breedId)") else { return }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error al obtener los detalles: \(error?.localizedDescription ?? "Desconocido")")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let details = try decoder.decode(DogBreedDetail.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.updateUI(with: details)
                    }
                } catch {
                    print("Error al decodificar los detalles: \(error.localizedDescription)")
                }
            }
            
            task.resume()
        }
        
        func updateUI(with details: DogBreedDetail) {
            breedLabel.text = details.title ?? "Desconocido"
            sizeLabel.text = details.size ?? "Desconocido"
            foodLabel.text = details.daily_food ?? "Desconocido"
            lifeExpectancyLabel.text = details.life_expectancy ?? "Desconocido"
            coatTypeLabel.text = details.coat_type ?? "Desconocido"
            temperamentLabel.text = details.temperament ?? "Desconocido"
            exerciseNeedLabel.text = details.exercise_needs ?? "Desconocido"
            
            // Cargar la imagen si existe
            if let imageUrlString = details.image, let imageUrl = URL(string: imageUrlString) {
                // Cargar la imagen asíncronamente
                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    guard let data = data, error == nil else { return }
                    
                    DispatchQueue.main.async {
                        self.breedImageView.image = UIImage(data: data)
                    }
                }.resume()
            } else {
                
                breedImageView.image = UIImage(named: "default_image")
            }
        }
    }
