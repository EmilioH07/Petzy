//
//  FoodViewController.swift
//  Petzy
//
//  Created by Emilio Herrera on 19/12/24.
//

import UIKit

class FoodViewController: UIViewController {
    
    var totalFoodInKg: Double = 0.0
    var foodAmountInGrams: Double = 0.0
    var initialFoodAmountInGrams: Double = 0.0
    
    
    @IBOutlet weak var foodProgressBar: UIProgressView!
    @IBOutlet weak var totalFoodLabel: UILabel!
    @IBOutlet weak var foodToFeedTextField: UITextField!
    @IBOutlet weak var totalFoodAmountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Cargar datos desde UserDefaults
        loadFoodData()
        updateProgressBarAndLabel()
        
        // Configurar para ocultar el teclado
        setupHideKeyboardOnTap()
    }
    
    private func setupHideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

    // Función para cargar datos desde UserDefaults
    private func loadFoodData() {
        let defaults = UserDefaults.standard

        foodAmountInGrams = defaults.double(forKey: "foodAmountInGrams")
        initialFoodAmountInGrams = defaults.double(forKey: "initialFoodAmountInGrams")

        if initialFoodAmountInGrams == 0 && foodAmountInGrams == 0 {
            initialFoodAmountInGrams = 0000 // Por ejemplo, 5kg.
            foodAmountInGrams = initialFoodAmountInGrams
            saveFoodData()
        }

        updateProgressBarAndLabel()
    }

    // Función para guardar los datos en UserDefaults
    private func saveFoodData() {
        let defaults = UserDefaults.standard
        defaults.set(foodAmountInGrams, forKey: "foodAmountInGrams")
        defaults.set(initialFoodAmountInGrams, forKey: "initialFoodAmountInGrams")
    }

    
    @IBAction func addFoodTapped(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Agregar comida",
            message: "Ingresa la cantidad de comida total en kilogramos:",
            preferredStyle: .alert
        )
                
        alertController.addTextField { textField in
            textField.placeholder = "Cantidad en kg"
            textField.keyboardType = .decimalPad
        }

        let addAction = UIAlertAction(title: "Agregar", style: .default) { [weak self] _ in
            guard let self = self,
                let foodText = alertController.textFields?.first?.text,
                let foodInKg = Double(foodText), foodInKg > 0 else { return }

                let foodInGrams = foodInKg * 1000

            // Actualiza la cantidad total e inicial
            self.foodAmountInGrams += foodInGrams
            self.initialFoodAmountInGrams = max(self.foodAmountInGrams, self.initialFoodAmountInGrams)

            // Guarda y actualiza la UI
            self.saveFoodData()
            self.updateProgressBarAndLabel()
        }
                
        alertController.addAction(addAction)
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
                
        present(alertController, animated: true)
    }
    
    
    
    @IBAction func feedDogTapped(_ sender: Any) {
        guard let foodToFeedText = foodToFeedTextField.text,
            let foodToFeedInGrams = Double(foodToFeedText), foodToFeedInGrams > 0 else {
            return
        }
                
        if foodToFeedInGrams > foodAmountInGrams {
            let alertController = UIAlertController(
                title: "¡Comida insuficiente!",
                message: "No tienes suficiente comida para alimentar al perro. Intenta con una cantidad menor.",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
            return
        }
                
        foodAmountInGrams -= foodToFeedInGrams
        saveFoodData()
                
        // Actualizar la barra de progreso y la etiqueta
        updateProgressBarAndLabel()
        foodToFeedTextField.text = ""
    }

    private func updateProgressBarAndLabel() {
        guard initialFoodAmountInGrams > 0 else {
            foodProgressBar.setProgress(0.0, animated: true)
            totalFoodLabel.text = "Total de comida: 0.00 kg"
            totalFoodAmountLabel.text = "0.00"
            return
        }

        // Calcular el porcentaje y actualizar la barra de progreso
        let percentage = foodAmountInGrams / initialFoodAmountInGrams
        foodProgressBar.setProgress(Float(percentage), animated: true)

        let remainingFoodInKg = foodAmountInGrams / 1000
        let totalFoodInKg = initialFoodAmountInGrams / 1000

        totalFoodLabel.text = "Total de comida: \(String(format: "%.2f", remainingFoodInKg)) kg"
        totalFoodAmountLabel.text = String(format: "%.2f", totalFoodInKg)
    }
}
