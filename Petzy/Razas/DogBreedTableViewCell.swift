//
//  DogBreedTableViewCell.swift
//  Petzy
//
//  Created by Emilio Herrera on 30/12/24.
//

import UIKit

class DogBreedTableViewCell: UITableViewCell {

    @IBOutlet weak var breedImage: UIImageView!
    @IBOutlet weak var breedLabel: UILabel!
    
    func configureCell(with dog: DogBreed) {
        breedLabel.text = dog.title
        
        if let urlString = dog.image, let url = URL(string: urlString) {
            breedImage.loadImage(from: url)
        } else {
            breedImage.image = UIImage(named: "defaultImage")
        }
    }

}
