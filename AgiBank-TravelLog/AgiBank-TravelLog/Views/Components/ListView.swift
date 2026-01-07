//
//  ListView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//

import SwiftUI

struct ListView: View {
    @State private var items = Array(1...20).map { "Item \($0)" }
    @State private var selectedItems: Set<String> = []
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        List(selection: $selectedItems) {
            Section("Lista Simples") {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .swipeActions {
                            Button(role: .destructive) {
                                deleteItem(item)
                            } label: {
                                Label("Excluir", systemImage: "trash")
                            }
                            
                            Button {
                                duplicateItem(item)
                            } label: {
                                Label("Duplicar", systemImage: "doc.on.doc")
                            }
                            .tint(.blue)
                        }
                }
            }
            
            Section("Lista com Ações") {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Image(systemName: "circle.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                        
                        Text(item)
                        
                        Spacer()
                        
                        if selectedItems.contains(item) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if selectedItems.contains(item) {
                            selectedItems.remove(item)
                        } else {
                            selectedItems.insert(item)
                        }
                    }
                }
            }
            
            Section("Lista Dinâmica") {
                ForEach($items, id: \.self) { $item in
                    TextField("Editar item", text: $item)
                        .textFieldStyle(.roundedBorder)
                }
                .onDelete { indexSet in
                    items.remove(atOffsets: indexSet)
                }
                .onMove { indices, newOffset in
                    items.move(fromOffsets: indices, toOffset: newOffset)
                }
            }
            
            Section("List Styles") {
                Text("Inset Grouped (Este estilo)")
                    .listRowBackground(Color.blue.opacity(0.1))
                
                Text("Plain")
                    .listRowBackground(Color.green.opacity(0.1))
                
                Text("Sidebar")
                    .listRowBackground(Color.orange.opacity(0.1))
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("List")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Adicionar") {
                    addItem()
                }
            }
        }
        .environment(\.editMode, $editMode)
    }
    
    private func addItem() {
        let newItem = "Item \(items.count + 1)"
        items.append(newItem)
    }
    
    private func deleteItem(_ item: String) {
        items.removeAll { $0 == item }
    }
    
    private func duplicateItem(_ item: String) {
        items.append("\(item) (cópia)")
    }
}
