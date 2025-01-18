//
//  ActivitiesViewController.swift
//  Petzy
//
//  Created by Emilio Herrera on 30/12/24.
//

import UIKit
import Network

class ActivitiesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var runcollectionView: UICollectionView!
    @IBOutlet weak var petFriendlyCollectionView: UICollectionView!
    
    var lugares: [Lugar] = []
    var plazasPetFriendly: [Plaza] = []
    var errorView: UIView?
    var monitor: NWPathMonitor?

    override func viewDidLoad() {
        super.viewDidLoad()
            
        // CollectionView
        runcollectionView.delegate = self
        runcollectionView.dataSource = self
        petFriendlyCollectionView.delegate = self
        petFriendlyCollectionView.dataSource = self
            
        // Configura la vista de error
        configureErrorView()
            
        // Inicia el monitoreo de la red
        monitorNetworkConnectivity()
            
        // Cargar los lugares desde la API
        fetchLugares()
        fetchPlazasPetFriendly()
    }
        
    
    func showError(message: String) {
        if errorView?.isHidden == false {
            return
        }
            
        if let label = errorView?.subviews.compactMap({ $0 as? UILabel }).first {
            label.text = message
        }
            
        errorView?.isHidden = false
    }
        
    func hideError() {
        errorView?.isHidden = true
    }

    // Configurar el monitoreo de la red
    func monitorNetworkConnectivity() {
        monitor = NWPathMonitor()
        let queue = DispatchQueue.global(qos: .background)
        monitor?.start(queue: queue)
        
        monitor?.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self.hideError()
                    self.fetchLugares()
                    self.fetchPlazasPetFriendly()
                } else {
                    self.showError(message: "Sin conexión a Internet.\nPor favor, verifica tu conexión.")
                    self.lugares = []
                    self.plazasPetFriendly = []
                    self.runcollectionView.reloadData()
                    self.petFriendlyCollectionView.reloadData()
                }
            }
        }
    }

    // Configuración de la vista de error
    func configureErrorView() {
        errorView = UIView(frame: self.view.bounds)
        errorView?.backgroundColor = UIColor.white
        self.view.addSubview(errorView!)
        
        let label = UILabel(frame: CGRect(x: 20, y: self.view.bounds.height / 2 - 50, width: self.view.bounds.width - 40, height: 100))
        label.text = "Sin conexión a Internet.\nPor favor, verifica tu conexión."
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        errorView?.addSubview(label)
        errorView?.isHidden = true
    }

    // Cargar lugares desde la API
    func fetchLugares() {
        guard let url = URL(string: "https://private-bb2ffb-actividades2.apiary-mock.com/activities/run_list") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error al cargar datos: \(error)")
                DispatchQueue.main.async {
                    self.showError(message: "No se pudo cargar la información de los lugares.")
            }
            return
        }
                
        guard let data = data else { return }
                
        do {
            let decoder = JSONDecoder()
            self.lugares = try decoder.decode([Lugar].self, from: data)
                    
            DispatchQueue.main.async {
                // Recargar el collection view con los nuevos datos
                self.runcollectionView.reloadData()
                self.hideError() 
            }
        }catch {
            print("Error al decodificar datos: \(error)")
            DispatchQueue.main.async {
                self.showError(message: "Error al procesar los datos de los lugares.")
            }
        }
        }
        task.resume()
    }

    // Cargar plazas pet-friendly desde la API
    func fetchPlazasPetFriendly() {
        guard let url = URL(string: "https://private-324614-actividades21.apiary-mock.com/activities/plazas_list") else { return }
            
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error al cargar datos de plazas pet-friendly: \(error)")
                DispatchQueue.main.async {
                self.showError(message: "No se pudo cargar la información de las plazas pet-friendly.")
            }
                return
            }
                
            guard let data = data else { return }
                
            do {
                // Decodificar los datos en el modelo PlazaPetFriendly
                let decoder = JSONDecoder()
                self.plazasPetFriendly = try decoder.decode([Plaza].self, from: data)
                    
                DispatchQueue.main.async {
                    // Recargar el collection view con los nuevos datos
                    self.petFriendlyCollectionView.reloadData()
                    self.hideError()  // Ocultar la vista de error si la carga fue exitosa
                }
            } catch {
                print("Error al decodificar datos de plazas pet-friendly: \(error)")
                DispatchQueue.main.async {
                    self.showError(message: "Error al procesar los datos de las plazas pet-friendly.")
                }
            }
        }
            
        task.resume()
    }

    // MARK: - Collection View DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == runcollectionView {
            return lugares.count
        } else {
            return plazasPetFriendly.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == runcollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RunCollectionViewCell", for: indexPath) as? RunCollectionViewCell else {
            return UICollectionViewCell()
            }
                
        // Configurar la celda con los datos del lugar
            let lugar = lugares[indexPath.row]
            cell.configure(with: lugar)
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetFriendlyCollectionViewCell", for: indexPath) as? PlazaCollectionViewCell else {
            return UICollectionViewCell()
        }
                
        // Configurar la celda con los datos de la plaza pet-friendly
        let plaza = plazasPetFriendly[indexPath.row]
            cell.configure(with: plaza)
                
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == runcollectionView {
            let lugar = lugares[indexPath.row]
            fetchLugarDetalle(lugar: lugar)
        } else {
            // Obtener el PlazaDetalle correspondiente
            let plaza = plazasPetFriendly[indexPath.row]
            fetchPlazaDetalle(plaza: plaza)
        }
    }

    // Obtener los detalles del lugar
    func fetchLugarDetalle(lugar: Lugar) {
        let urlString = "https://private-bb2ffb-actividades2.apiary-mock.com/activities/run_list/\(lugar.id)"
            
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error al cargar los detalles: \(error)")
                return
            }
                
            guard let data = data else { return }
                
            do {
                // Decodificar los detalles del lugar
                let decoder = JSONDecoder()
                let lugarDetalle = try decoder.decode(LugarDetalle.self, from: data)
                    
                DispatchQueue.main.async {
                    // Pasar los detalles del lugar al MapViewController
                    self.navigateToMapViewController(lugarDetalle: lugarDetalle)
                }
            } catch {
                print("Error al decodificar los detalles: \(error)")
            }
        }
            
        task.resume()
    }

    func fetchPlazaDetalle(plaza: Plaza) {
        let urlString = "https://private-324614-actividades21.apiary-mock.com/activities/plazas_list/\(plaza.id)"
            
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error al cargar los detalles de la plaza: \(error)")
                return
            }
                
            guard let data = data else { return }
            
            do {
                // Decodificar los detalles de la plaza
                let decoder = JSONDecoder()
                let plazaDetalle = try decoder.decode(PlazaDetalle.self, from: data)
                    
                DispatchQueue.main.async {
                    // Pasar los detalles de la plaza al MapViewController
                    self.navigateToMapViewController(plazaDetalle: plazaDetalle)
                }
            } catch {
                print("Error al decodificar los detalles de la plaza: \(error)")
            }
        }
        
        task.resume()
    }

    // Navegar a MapViewController pasando los detalles del lugar
    func navigateToMapViewController(lugarDetalle: LugarDetalle? = nil, plazaDetalle: PlazaDetalle? = nil) {
        let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            
        if let lugar = lugarDetalle {
            mapVC.lugarDetalle = lugar
        }
            
        if let plaza = plazaDetalle {
            mapVC.plazaDetalle = plaza
        }
            
        navigationController?.pushViewController(mapVC, animated: true)
    }
}
