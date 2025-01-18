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
    @IBOutlet weak var favoriteButton: UIButton!
    
    var favoriteAction: (() -> Void)? // Closure para manejar el botón
    var contactAction: (() -> Void)?

    func configureCell(with dog: AdoptionAPI, isFavorite: Bool) {
        adoptionName.text = dog.nombre
        adoptionAge.text = dog.edad
        adoptionUbic.text = dog.ubicacion

        if let urlString = dog.image, let url = URL(string: urlString) {
            adoptionImage.loadImage(from: url)
        } else {
            adoptionImage.image = UIImage(named: "defaultImage")
        }

        // Asegúrate de que el favoriteButton no sea nil
        guard let favoriteButton = favoriteButton else {
            return
        }

        // Cambiar la imagen del botón dependiendo de si es favorito o no
        let buttonImage = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        favoriteButton.setImage(buttonImage, for: .normal)
        
        let cornerRadius: CGFloat = 10
        adoptionImage.layer.cornerRadius = cornerRadius
        adoptionImage.clipsToBounds = true
        
    }

    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        favoriteAction?()
    }
    
    @IBAction func celButtonTapped(_ sender: Any) {
        contactAction?()
    }
    
    
    
    }
