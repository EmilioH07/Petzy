//
//  MapViewController.swift
//  Petzy
//
//  Created by Emilio Herrera on 30/12/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var lugarDetalle: LugarDetalle?  // Recibimos los detalles del lugar
        var plazaDetalle: PlazaDetalle?
           
        override func viewDidLoad() {
            super.viewDidLoad()
                
            // Comprobar si tenemos detalles de lugar
            if let lugarDetalle = lugarDetalle {
                // Mostrar el nombre del lugar en el label
                nameLabel.text = lugarDetalle.title
                let latitude = Double(lugarDetalle.latitud) ?? 0.0
                let longitude = Double(lugarDetalle.longitud) ?? 0.0
                    
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
                    
                // Establecer la región del mapa
                mapView.setRegion(region, animated: true)
                    
                // Añadir un marcador en la ubicación del lugar
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = lugarDetalle.title
                mapView.addAnnotation(annotation)
            }
            // Comprobar si tenemos detalles de plaza
            else if let plazaDetalle = plazaDetalle {
                // Mostrar el nombre de la plaza en el label
                nameLabel.text = plazaDetalle.title
                let latitude = Double(plazaDetalle.latitud) ?? 0.0
                let longitude = Double(plazaDetalle.longitud) ?? 0.0
                    
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    
                // Establecer la región del mapa
                mapView.setRegion(region, animated: true)
                    
                // Añadir un marcador en la ubicación de la plaza
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = plazaDetalle.title
                mapView.addAnnotation(annotation)
            }
            else {
                // Si no se reciben detalles, mostrar un mensaje de error
                print("No se recibieron detalles de lugar o plaza.")
            }
        }

        // Función para abrir la ubicación en Apple Maps
        @IBAction func openInAppleMaps(_ sender: UIButton) {
            if let lugarDetalle = lugarDetalle {
                let latitude = Double(lugarDetalle.latitud) ?? 0.0
                let longitude = Double(lugarDetalle.longitud) ?? 0.0
                let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let regionSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                let region = MKCoordinateRegion(center: coordinates, span: regionSpan)

                // Crear la URL para abrir Apple Maps
                let mapURL = "maps://?ll=\(coordinates.latitude),\(coordinates.longitude)&q=\(lugarDetalle.title)"
                
                if let url = URL(string: mapURL) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        print("No se puede abrir Apple Maps")
                    }
                }
            } else if let plazaDetalle = plazaDetalle {
                let latitude = Double(plazaDetalle.latitud) ?? 0.0
                let longitude = Double(plazaDetalle.longitud) ?? 0.0
                let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let regionSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                let region = MKCoordinateRegion(center: coordinates, span: regionSpan)

                // Crear la URL para abrir Apple Maps
                let mapURL = "maps://?ll=\(coordinates.latitude),\(coordinates.longitude)&q=\(plazaDetalle.title)"
                
                if let url = URL(string: mapURL) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        print("No se puede abrir Apple Maps")
                    }
                }
            }
        }
    }
