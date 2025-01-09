//
//  FavoriteDogsTableViewController.swift
//  Petzy
//
//  Created by Emilio Herrera on 08/01/25.
//

import UIKit

class FavoriteDogsTableViewController: UITableViewController {
    
    var favoriteDogIds = Set<String>()
    var dogsForAdoption = [AdoptionAPI]()
    var favoriteDogs: [AdoptionAPI] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 280
        loadFavoriteDogs()  // Filtrar los perros favoritos
        tableView.reloadData()
    }

    func loadFavoriteDogs() {
        // Filtrar los perros favoritos según los IDs almacenados
        favoriteDogs = dogsForAdoption.filter { favoriteDogIds.contains($0.id) }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteDogs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdoptionCell", for: indexPath) as! AdoptionTableViewCell
        let dog = favoriteDogs[indexPath.row]
        cell.configureCell(with: dog, isFavorite: true)
        return cell
    }
}
