//
//  AgiBank_TravelLogApp.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 10/12/25.
//

import SwiftUI
//original
//@main
//struct AgiBank_TravelLogApp: App {
//    var body: some Scene {
//        WindowGroup {
//            MainView()// ContentView()
//        }
//    }
//}


import SwiftUI
import UIKit
//chamando thread
@main
struct AgiBank_TravelLogApp: App {
    var body: some Scene {
        WindowGroup {
            // Opção: usar o helper que cria um UINavigationController com a FirstVC
            UIKitRootView()
        }
    }
}

// Um wrapper SwiftUI para o UINavigationController com UIKitFirstViewController
struct UIKitRootView: View {
    var body: some View {
        UIKitContainer {
            makeUIKitDemoRoot() // retorna UINavigationController(root: UIKitFirstViewController())
        }
        .ignoresSafeArea() // para preencher a tela
    }
}

// Representable para exibir UINavigationController/UIViewController no SwiftUI
struct UIKitContainer: UIViewControllerRepresentable {
    let builder: () -> UIViewController
    init(_ builder: @escaping () -> UIViewController) { self.builder = builder }
    func makeUIViewController(context: Context) -> UIViewController { builder() }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}


//import SwiftUI
//
//@main
//struct AgiBank_TravelLogApp: App {
//    var body: some Scene {
//        WindowGroup {
//            SwiftUIDispatchDemoRoot()
//        }
//    }
//}


//verify
/**WindowGroup {
 // UIKit
 // UIKitRootView()

 // SwiftUI DispatchQueue
 // SwiftUIDispatchDemoRoot()

 // SwiftUI async/await
 SwiftUIAsyncDemoRoot()
}
 */
