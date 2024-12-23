//
//  ChartView.swift
//  Petzy
//
//  Created by Emilio Herrera on 19/12/24.
//

import UIKit

class ChartView: UIView {
    
    var percentage: Double = 0.0
        
        // Método para actualizar el porcentaje y redibujar el gráfico
        func updateChart(with percentage: Double) {
            self.percentage = min(max(percentage, 0.0), 1.0)
            setNeedsDisplay()
        }
        
        // Método para dibujar la gráfica circular
        override func draw(_ rect: CGRect) {
            guard let context = UIGraphicsGetCurrentContext() else { return }
            
            let startAngle: CGFloat = -.pi / 2
            let endAngle: CGFloat = startAngle + CGFloat(percentage * 2 * .pi)
            
            let radius = min(bounds.width, bounds.height) / 2
            let center = CGPoint(x: bounds.midX, y: bounds.midY)
            
            context.setFillColor(UIColor.lightGray.cgColor)
            context.beginPath()
            context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: startAngle + 2 * .pi, clockwise: false)
            context.closePath()
            context.fillPath()
            
            context.setFillColor(UIColor.green.cgColor)
            context.beginPath()
            context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            context.closePath()
            context.fillPath()
            
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(2)
            context.strokeEllipse(in: CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: bounds.height))
        }
    }
