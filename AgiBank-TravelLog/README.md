# AgiBank-TravelLog
This project will be used to teach SwiftUI in an immersion program for AgiBank students. It will be an application for making reservations, checking information about currencies, travel, schedules, flights, and hotels, among other things.

//O que vamos construir hoje?

✅ criar viewcontroler para esse content
✅ criar cordinator para views -> chamarem components
✅ criar models e viewmodels


✅ criar  login com auth + firebase do zero
✅ chamar api de maps = navegacao, coordenadas, timeout, threads
✅ criar modal + factory e design patterns
✅ + do swiftui + teoria, structs e classes
✅ threads com cliques nos botoes e prints
✅ adicionar assets
✅ adicionar packages
✅ separacao de conceitos da view e da viewmodel

TAREFA 
CRIAR UMA BRANCH COM SEU NOME DESSE PROJETO PARTINDO DA THEORY_BRANCH
CRIAR UMA TELA SIMPLES COM UM BOTÃO QUE VAI PARA OUTRA TELA SIMPLES COM UM BOTÃO DE VOLTAR
USAR THREAD, COORDINATOR, VIEWCONTROLLER E VIEW





## Exemplo: Mudança de Threads entre duas telas (UIKit)

Neste exemplo temos duas telas com cores diferentes e botões que executam trabalho em background e retornam à thread principal, com prints no console indicando em qual thread o código está sendo executado.

```swift
import UIKit

final class FirstViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue

        let button = UIButton(type: .system)
        button.setTitle("Ir para Segunda Tela", for: .normal)
        button.addTarget(self, action: #selector(goToSecond), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func goToSecond() {
        print("[First] Toque no botão — thread atual: \(Thread.isMainThread ? "main" : "background")")

        // Simula trabalho em background e volta para a main
        DispatchQueue.global(qos: .userInitiated).async {
            print("[First] Executando no background — thread: \(Thread.isMainThread ? "main" : "background")")
            // Simula um pequeno trabalho
            Thread.sleep(forTimeInterval: 0.3)

            DispatchQueue.main.async {
                print("[First] Voltando para a main — thread: \(Thread.isMainThread ? "main" : "background")")
                let vc = SecondViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

final class SecondViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen

        let button = UIButton(type: .system)
        button.setTitle("Executar tarefa e voltar", for: .normal)
        button.addTarget(self, action: #selector(runTaskAndPop), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func runTaskAndPop() {
        print("[Second] Toque no botão — thread atual: \(Thread.isMainThread ? "main" : "background")")

        // Simula trabalho em background
        DispatchQueue.global(qos: .utility).async {
            print("[Second] Executando no background — thread: \(Thread.isMainThread ? "main" : "background")")
            // Simula um trabalho mais demorado
            Thread.sleep(forTimeInterval: 0.5)

            DispatchQueue.main.async {
                print("[Second] Voltando para a main — thread: \(Thread.isMainThread ? "main" : "background")")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// Para iniciar:
// let nav = UINavigationController(rootViewController: FirstViewController())
// window.rootViewController = nav


import SwiftUI

struct FirstView: View {
    @State private var isNavigating = false
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue
                    .ignoresSafeArea()
                
                VStack {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding()
                    }
                    
                    Button("Ir para Segunda Tela") {
                        print("[First] Toque no botão — thread atual: \(Thread.isMainThread ? "main" : "background")")
                        performBackgroundTask()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
                    .foregroundColor(.blue)
                    .disabled(isLoading)
                }
                .navigationDestination(isPresented: $isNavigating) {
                    SecondView()
                }
            }
        }
    }
    
    private func performBackgroundTask() {
        isLoading = true
        
        // Usando Task para executar trabalho em background
        Task {
            print("[First] Executando no background — thread: \(Thread.isMainThread ? "main" : "background")")
            
            // Simula trabalho em background
            try? await Task.sleep(for: .milliseconds(300))
            
            // Volta para a thread principal
            await MainActor.run {
                print("[First] Voltando para a main — thread: \(Thread.isMainThread ? "main" : "background")")
                isLoading = false
                isNavigating = true
            }
        }
    }
}

struct SecondView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            
            VStack {
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                }
                
                Button("Executar tarefa e voltar") {
                    print("[Second] Toque no botão — thread atual: \(Thread.isMainThread ? "main" : "background")")
                    performBackgroundTaskAndPop()
                }
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .foregroundColor(.green)
                .disabled(isLoading)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func performBackgroundTaskAndPop() {
        isLoading = true
        
        Task {
            print("[Second] Executando no background — thread: \(Thread.isMainThread ? "main" : "background")")
            
            // Simula trabalho mais demorado em background
            try? await Task.sleep(for: .milliseconds(500))
            
            // Volta para a thread principal
            await MainActor.run {
                print("[Second] Voltando para a main — thread: \(Thread.isMainThread ? "main" : "background")")
                isLoading = false
                dismiss()
            }
        }
    }
}

// Exemplo alternativo usando DispatchQueue (mais próximo do UIKit)
struct FirstViewDispatchQueue: View {
    @State private var isNavigating = false
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue
                    .ignoresSafeArea()
                
                VStack {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding()
                    }
                    
                    Button("Ir para Segunda Tela (DispatchQueue)") {
                        print("[First] Toque no botão — thread atual: \(Thread.isMainThread ? "main" : "background")")
                        performBackgroundTaskWithDispatchQueue()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
                    .foregroundColor(.blue)
                    .disabled(isLoading)
                }
                .navigationDestination(isPresented: $isNavigating) {
                    SecondViewDispatchQueue()
                }
            }
        }
    }
    
    private func performBackgroundTaskWithDispatchQueue() {
        isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            print("[First] Executando no background — thread: \(Thread.isMainThread ? "main" : "background")")
            
            // Simula trabalho em background
            Thread.sleep(forTimeInterval: 0.3)
            
            DispatchQueue.main.async {
                print("[First] Voltando para a main — thread: \(Thread.isMainThread ? "main" : "background")")
                isLoading = false
                isNavigating = true
            }
        }
    }
}

struct SecondViewDispatchQueue: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            
            VStack {
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                }
                
                Button("Executar tarefa e voltar (DispatchQueue)") {
                    print("[Second] Toque no botão — thread atual: \(Thread.isMainThread ? "main" : "background")")
                    performBackgroundTaskWithDispatchQueue()
                }
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .foregroundColor(.green)
                .disabled(isLoading)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func performBackgroundTaskWithDispatchQueue() {
        isLoading = true
        
        DispatchQueue.global(qos: .utility).async {
            print("[Second] Executando no background — thread: \(Thread.isMainThread ? "main" : "background")")
            
            // Simula trabalho mais demorado em background
            Thread.sleep(forTimeInterval: 0.5)
            
            DispatchQueue.main.async {
                print("[Second] Voltando para a main — thread: \(Thread.isMainThread ? "main" : "background")")
                isLoading = false
                dismiss()
            }
        }
    }
}

// App principal com ambas as implementações
struct ContentView: View {
    var body: some View {
        TabView {
            FirstView()
                .tabItem {
                    Label("Task/Async", systemImage: "t.square.fill")
                }
            
            FirstViewDispatchQueue()
                .tabItem {
                    Label("DispatchQueue", systemImage: "d.square.fill")
                }
        }
    }
}

// Para rodar o app
@main
struct ThreadsExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
