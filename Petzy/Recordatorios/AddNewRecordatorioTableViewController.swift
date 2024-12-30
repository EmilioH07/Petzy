//
//  AddNewRecordatorioTableViewController.swift
//  Petzy
//
//  Created by Emilio Herrera on 19/12/24.
//

import UIKit

protocol AddNewRecordatorioDelegate: AnyObject {
    func didCreateRecordatorio(_ recordatorio: Recordatorio)
}

class AddNewRecordatorioTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let options = ["Consulta veterinaria", "Compra de comida", "Vacuna", "Corte de pelo", "Otro"]
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var hourPicker: UIDatePicker!
    @IBOutlet weak var namePlace: UITextField!
    @IBOutlet weak var notes: UITextView!

    weak var delegate: AddNewRecordatorioDelegate?
    var recordatorio: Recordatorio?

    var pickerView: UIPickerView!
                
    override func viewDidLoad() {
        super.viewDidLoad()
                    
        setupPickerView()
        textField.inputView = pickerView
                
        // Añadir botón "Hecho" en la parte superior para cerrar el picker
        let doneButton = UIBarButtonItem(title: "Hecho", style: .done, target: self, action: #selector(doneTapped))
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.setItems([doneButton], animated: false)
        textField.inputAccessoryView = toolbar
                    
        if let recordatorio = recordatorio {
            // Precargar los datos del recordatorio
            textField.text = recordatorio.tipo
            namePlace.text = recordatorio.lugar
            notes.text = recordatorio.notas
                            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            if let fecha = dateFormatter.date(from: recordatorio.fecha) {
                datePicker.date = fecha
            }
                            
            let hourFormatter = DateFormatter()
            hourFormatter.timeStyle = .short
            if let hora = hourFormatter.date(from: recordatorio.hora) {
                hourPicker.date = hora
            }
                            
            if let index = options.firstIndex(of: recordatorio.tipo) {
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
        }
    }
    
    func setupPickerView() {
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    @objc func doneTapped() {
        view.endEditing(true)
    }
                
    @IBAction func saveButtonTapped(_ sender: Any) {
        // Validar que los campos tengan datos
        guard let tipo = textField.text,
        let lugar = namePlace.text,
        !tipo.isEmpty, !lugar.isEmpty else {
        let alert = UIAlertController(title: "Error", message: "Por favor completa todos los campos.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        return
    }
                    
        // Formatear la fecha y hora
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let fecha = dateFormatter.string(from: datePicker.date)
                        
        let hourFormatter = DateFormatter()
        hourFormatter.timeStyle = .short
        let hora = hourFormatter.string(from: hourPicker.date)
                        
        // Si existe un recordatorio, actualizarlo
        if let recordatorio = recordatorio {
            recordatorio.tipo = tipo
            recordatorio.fecha = fecha
            recordatorio.hora = hora
            recordatorio.lugar = lugar
            recordatorio.notas = notes.text ?? ""
                            
            // Enviar el recordatorio actualizado al delegado
            delegate?.didCreateRecordatorio(recordatorio)
        } else {
            // Si no existe un recordatorio, crear uno nuevo
            let recordatorio = Recordatorio(tipo: tipo, fecha: fecha, hora: hora, lugar: lugar, notas: notes.text ?? "")
            delegate?.didCreateRecordatorio(recordatorio)
        }
                    
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
    // Confirmar la acción de cancelar
        let alert = UIAlertController(title: "Cancelar", message: "¿Estás seguro de que deseas cancelar?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sí", style: .destructive, handler: { _ in
        self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                        
        present(alert, animated: true)
    }
    

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = options[row]
    }
                
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = options[row]
        let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "Arial", size: 18)!,
        .foregroundColor: UIColor.black
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? AddNewRecordatorioTableViewController {
            if let recordatorio = sender as? Recordatorio {
                destinationVC.recordatorio = recordatorio
            }
        }
    }
}
