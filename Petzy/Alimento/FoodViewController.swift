//
//  FoodViewController.swift
//  Petzy
//
//  Created by Emilio Herrera on 19/12/24.
//

import UIKit

class FoodViewController: UIViewController {
    
    var foodAmount: Double = 0.0
    let dailyConsumption: Double = 20.0

    
    @IBOutlet weak var foodChartView: ChartView!
    
    @IBOutlet weak var forecastLabel: UILabel!
        
   
    // Acciones de los botones
    @IBAction func addFoodTapped(_ sender: UIButton) {
    // Acción para añadir comida
        foodAmount += 50.0
        updateChartAndForecast()
    }
    
    @IBAction func feedDogTapped(_ sender: UIButton) {
        // Acción para restar comida
        foodAmount -= 20.0
        if foodAmount < 0 {
            foodAmount = 0
        }
        updateChartAndForecast()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupChartView()
        setupForecastLabel()
    }
    
    private func setupChartView() {
        foodChartView.backgroundColor = .lightGray
        foodChartView.layer.cornerRadius = 100
    }
        
    private func setupForecastLabel() {
        forecastLabel.text = "Pronóstico: 0 días"
        forecastLabel.textAlignment = .center
        forecastLabel.font = UIFont.systemFont(ofSize: 16)
    }
    
    private func updateChartAndForecast() {
        // Actualizar la gráfica
        let percentage = foodAmount / 100.0
        foodChartView.updateChart(with: percentage)
        
        // Calcular y actualizar el pronóstico
        let forecast = foodAmount / dailyConsumption
        forecastLabel.text = "Pronóstico: \(Int(forecast)) días"
    }
}
