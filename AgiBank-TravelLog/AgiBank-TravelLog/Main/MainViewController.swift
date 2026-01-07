//
//  MainViewController.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//


import UIKit
import SwiftUI

//final class MainViewController: UIViewController {
//   
//    private let coordinator = AppCoordinator()
////
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        coordinator.start()
//        configNavigation(nav: coordinator.nav)
//    }
//
////
////
////    
//    private func configNavigation(nav: UINavigationController) {
//        addViews(nav)
//        setupConstraints(nav)
//    }
//    
//    func addViews(_ navigationController: UINavigationController) {
//        addChild(navigationController)
//    }
////    
//    func setupConstraints(_ navigationController: UINavigationController) {
//       navigationController.view.translatesAutoresizingMaskIntoConstraints = false
//        
//       view.addSubview(navigationController.view)
//        
//       NSLayoutConstraint.activate([
//           navigationController.view.topAnchor.constraint(equalTo: view.topAnchor),
//           navigationController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//           navigationController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//           navigationController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//       ])
//       navigationController.didMove(toParent: self)// define de onde ele veio
//   }
//}


import SwiftUI

struct MainView: View {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.nav) {
            coordinator.rootView
                .navigationDestination(for: Route.self) { route in
                    coordinator.view(for: route) //define o para onde vai
                }
        }
        .environmentObject(coordinator)//define o de onde veio
    }
}
