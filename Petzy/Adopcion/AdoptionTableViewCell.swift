//
//  AdoptionTableViewCell.swift
//  Petzy
//
//  Created by Emilio Herrera on 17/12/24.
//

import UIKit

class AdoptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var adoptionImage: UIImageView!
    @IBOutlet weak var adoptionName: UILabel!
    @IBOutlet weak var adoptionUbic: UILabel!
    @IBOutlet weak var adoptionAge: UILabel!
    
    func configureCell(with dog: AdoptionAPI) {
        adoptionName.text = dog.nombre
        adoptionAge.text = dog.edad
        adoptionUbic.text = dog.ubicacion
        
        if let urlString = dog.image, let url = URL(string: urlString) {
            adoptionImage.loadImage(from: url)
        } else {
            adoptionImage.image = UIImage(named: "defaultImage")
        }
    }
}
