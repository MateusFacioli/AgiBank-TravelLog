//
//  PickerView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//

import SwiftUI

struct PickerView: View {
    @State private var selecionado = 0
    @State private var filtro = "0"
    @State private var corSelecionada = "Vermelho"
    
    let cores = ["Vermelho", "Verde", "Azul", "Amarelo"]
    
    var body: some View {
        Form {
            Section("Picker Menu") {
                Picker("Selecione uma opção", selection: $selecionado) {
                    Text("Opção 1").tag(0)
                    Text("Opção 2").tag(1)
                    Text("Opção 3").tag(2)
                }
                .pickerStyle(.menu)
                
                Text("Opção selecionada: \(selecionado + 1)")
            }
            
            Section("Picker Segmented") {
                Picker("Filtro", selection: $filtro) {
                    Text("Todos").tag("0")
                    Text("Ativos").tag("1")
                    Text("Inativos").tag("2")
                }
                .pickerStyle(.segmented)
                
                Text("Filtro: \(filtro == "0" ? "Todos" : filtro == "1" ? "Ativos" : "Inativos")")
            }
            
            Section("Wheel Picker") {
                Picker("Cor", selection: $corSelecionada) {
                    ForEach(cores, id: \.self) { cor in
                        Text(cor)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 150)
            }
        }
        .navigationTitle("Picker")
    }
}
