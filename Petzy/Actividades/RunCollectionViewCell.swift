//
//  RunCollectionViewCell.swift
//  Petzy
//
//  Created by Emilio Herrera on 30/12/24.
//

import UIKit

class RunCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with activity: Lugar) {
            titleLabel.text = activity.title
            if let url = URL(string: activity.image) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self.imageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
            
        // Redondear los bordes de la imagen
        imageView.layer.cornerRadius = 10 
        imageView.layer.masksToBounds = true  // Asegura que la imagen se recorte dentro del contorno redondeado
    }
}
