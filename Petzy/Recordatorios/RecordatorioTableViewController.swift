//
//  RecordatorioTableViewController.swift
//  Petzy
//
//  Created by Emilio Herrera on 19/12/24.
//

import UIKit

class RecordatorioTableViewController: UITableViewController, AddNewRecordatorioDelegate {
    
    // Array para almacenar los recordatorios
    var recordatorios: [Recordatorio] = []
    
    @IBOutlet weak var addReminderButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recordatorios"
        setupTableView()
        setupAddButton()
        
        // Cargar los recordatorios desde UserDefaults
        if let loadedRecordatorios = UserDefaults.standard.loadRecordatorios() {
            recordatorios = loadedRecordatorios
        }
        
        tableView.reloadData()
    }


    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecordatorioCell")
    }

    func setupAddButton() {
        addReminderButton.target = self
        addReminderButton.action = #selector(addNewRecordatorio)
    }

    // Acción para abrir la vista de añadir recordatorio
    @objc func addNewRecordatorio() {
        // Navegar a la vista de AddNewRecordatorioTableViewController
        if let addRecordatorioVC = storyboard?.instantiateViewController(withIdentifier: "AddNewRecordatorioTableViewController") as? AddNewRecordatorioTableViewController {
            addRecordatorioVC.delegate = self // Configurar el delegado
            navigationController?.pushViewController(addRecordatorioVC, animated: true)
        }
    }

    // MARK: - AddNewRecordatorioDelegate

    func didCreateRecordatorio(_ recordatorio: Recordatorio) {
        // Añadir el nuevo recordatorio al array
        recordatorios.append(recordatorio)
        
        // Guardar los recordatorios actualizados en UserDefaults
        UserDefaults.standard.saveRecordatorios(recordatorios)
        
        // Recargar la tabla
        tableView.reloadData()
    }

    // MARK: - Swipe to delete
        
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Eliminar") { (action, indexPath) in
            // Eliminar el recordatorio del array
            self.recordatorios.remove(at: indexPath.row)
                
            // Guardar los cambios en UserDefaults
            UserDefaults.standard.saveRecordatorios(self.recordatorios)
                    
            // Eliminar la fila de la tabla
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
            
        return [deleteAction]
    }

    // MARK: - TableView DataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordatorios.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordatorioCell", for: indexPath)
        let recordatorio = recordatorios[indexPath.row]
        cell.textLabel?.text = "\(recordatorio.tipo) - \(recordatorio.fecha)"
        return cell
    }

    // MARK: - TableView Delegate (Opcional)

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recordatorio = recordatorios[indexPath.row]

    // Realiza el segue hacia AddNewRecordatorioTableViewController
        performSegue(withIdentifier: "showReminderDetails", sender: recordatorio)
                    
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Prepare for Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReminderDetails" {
            if let destinationVC = segue.destination as? AddNewRecordatorioTableViewController,
               let recordatorio = sender as? Recordatorio {
                // Pasar el recordatorio seleccionado a la vista de detalle para editarlo
                destinationVC.recordatorio = recordatorio
            }
        }
    }
}
