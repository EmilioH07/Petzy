//
//  DogBreedTableViewCell.swift
//  Petzy
//
//  Created by Emilio Herrera on 17/12/24.
//

import UIKit

class DogBreedTableViewCell: UITableViewCell {

    @IBOutlet weak var breedImageView: UIImageView!
    @IBOutlet weak var breedLabel: UILabel!

    override func awakeFromNib() {
            super.awakeFromNib()
            setupCell()
        }

        func setupCell() {
        }

        func configureCell(with breed: DogBreed) {
            breedLabel.text = breed.title
            
            if let imageString = breed.image, let imageUrl = URL(string: imageString) {
                downloadImage(from: imageUrl) { image in
                    DispatchQueue.main.async {
                        self.breedImageView.image = image
                    }
                }
            }
        }

        func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error al descargar la imagen: \(error?.localizedDescription ?? "Desconocido")")
                    completion(nil)
                    return
                }

                if let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }.resume()
        }
    }
