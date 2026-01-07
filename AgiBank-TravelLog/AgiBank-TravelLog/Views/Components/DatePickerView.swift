//
//  DatePickerView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//

import SwiftUI

struct DatePickerView: View {
    @State private var data = Date()
    @State private var hora = Date()
    @State private var dataCompleta = Date()
    
    var body: some View {
        Form {
            Section("DatePicker - Data") {
                DatePicker("Data de Nascimento",
                          selection: $data,
                          displayedComponents: .date)
                
                Text("Data selecionada: \(data.formatted(date: .long, time: .omitted))")
            }
            
            Section("DatePicker - Hora") {
                DatePicker("Horário",
                          selection: $hora,
                          displayedComponents: .hourAndMinute)
                
                Text("Hora selecionada: \(hora.formatted(date: .omitted, time: .shortened))")
            }
            
            Section("DatePicker - Data e Hora") {
                DatePicker("Data e Hora",
                          selection: $dataCompleta,
                          displayedComponents: [.date, .hourAndMinute])
                
                Text("Data completa: \(dataCompleta.formatted())")
            }
            
            Section("DatePicker com Range") {
                DatePicker("Data Limite",
                          selection: $data,
                          in: Date()...Date().addingTimeInterval(86400 * 30),
                          displayedComponents: .date)
            }
        }
        .navigationTitle("DatePicker")
    }
}
