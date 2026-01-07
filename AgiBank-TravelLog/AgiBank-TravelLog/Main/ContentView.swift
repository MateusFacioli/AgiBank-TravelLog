//
//  ContentView.swift
//  AgiBank-Theory
//
//  Created by Mateus Rodrigues on 10/12/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("📐 Layouts e Containers") {
                    NavigationLink("📱 Stacks", destination: StacksView())
                    NavigationLink("📜 ScrollView", destination: ScrollViewExample())
                    NavigationLink("📋 List", destination: ListView())
                }
                
                Section("Componentes Básicos") {
                    NavigationLink("📝 TextField", destination: TextFieldView())
                    NavigationLink("🎯 Picker", destination: PickerView())
                    NavigationLink("📅 DatePicker", destination: DatePickerView())
                    NavigationLink("📊 Slider e Stepper", destination: SliderStepperView())
                    NavigationLink("🔘 Toggle", destination: ToggleView())
                }
                
                Section("Alertas e Diálogos") {
                    NavigationLink("⚠️ Alert", destination: AlertView())
                    NavigationLink("🗂️ ConfirmationDialog V1", destination: ConfirmationDialogV1View())
                    NavigationLink("🧩 ConfirmationDialog V2 com Enum", destination: ConfirmationDialogV2View())
                }
                
                Section("Gerenciamento de Estado") {
                    NavigationLink("📌 @State", destination: StateView())
                    NavigationLink("🔗 @Binding", destination: BindingView())
                    NavigationLink("🔄 @ObservedObject", destination: ObservedObjectView())
                    NavigationLink("🏛️ @StateObject", destination: StateObjectView())
                    NavigationLink("🌐 @EnvironmentObject", destination: EnvironmentObjectView())
                }
            }
            .navigationTitle("AgiBank Theory")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
