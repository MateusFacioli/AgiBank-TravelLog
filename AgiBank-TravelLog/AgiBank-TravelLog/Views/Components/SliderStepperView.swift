//
//  SliderStepperView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//

import SwiftUI

struct SliderStepperView: View {
    @State private var valor = 0.5
    @State private var quantidade = 1
    @State private var idade = 18
    @State private var porcentagem = 50.0
    
    var body: some View {
        Form {
            Section("Slider Básico") {
                Slider(value: $valor, in: 0...1)
                Text("Valor: \(valor, specifier: "%.2f")")
            }
            
            Section("Slider com Step") {
                Slider(value: $porcentagem, in: 0...100, step: 5)
                Text("Porcentagem: \(Int(porcentagem))%")
            }
            
            Section("Slider com Labels") {
                Slider(value: $valor, in: 0...1) {
                    Text("Intensidade")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("1")
                }
            }
            
            Section("Stepper Básico") {
                Stepper("Quantidade: \(quantidade)",
                       value: $quantidade,
                       in: 1...10)
                
                Stepper("", value: $quantidade)
                    .labelsHidden()
            }
            
            Section("Stepper com Formatação") {
                Stepper(value: $idade, in: 0...120, step: 1) {
                    Text("Idade: \(idade) anos")
                }
            }
        }
        .navigationTitle("Slider & Stepper")
    }
}
