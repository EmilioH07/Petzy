//
//  AppDelegate.swift
//  Petzy
//
//  Created by Emilio Herrera on 17/12/24.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var persistentContainer: NSPersistentContainer!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Cargar el contenedor de Core Data de forma asíncrona
        loadPersistentContainer()
        return true
    }

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Liberar recursos específicos si es necesario
    }

    // MARK: - Core Data stack

    private func loadPersistentContainer() {
        // Crear el contenedor de Core Data
        let container = NSPersistentContainer(name: "Petzy")
        
        DispatchQueue.global(qos: .userInitiated).async {
            container.loadPersistentStores { storeDescription, error in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
                
                // Configurar el contenedor en el hilo principal si es necesario
                DispatchQueue.main.async {
                    self.persistentContainer = container
                    print("Core Data Stack inicializado con éxito.")
                }
            }
        }
    }

    // MARK: - Core Data Saving support

    func saveContext() {
        guard let context = persistentContainer?.viewContext else { return }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
