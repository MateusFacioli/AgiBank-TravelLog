# ``DestinationCardViewModel``

ViewModel responsável por fornecer dados e lógica para o cartão de destino na interface.
Gerencia avaliações, enriquecimento de dados, favoritos e compartilhamento.

## Overview

`DestinationCardViewModel` centraliza a lógica e o estado necessários para exibir e interagir com um destino de viagem na interface do usuário. Ela mantém os dados reativos (usando @Published) e oferece métodos para enriquecimento de informações, marcação de favoritos e compartilhamento, tudo protegido para uso em SwiftUI.

### Modificadores especiais
- `@MainActor`: Garante que toda a lógica e atualização de UI aconteçam na thread principal, evitando condições de concorrência.
- `@Published`: Permite que propriedades notificam SwiftUI a cada atualização, garantindo interface sempre sincronizada (explicado na primeira ocorrência em comentários no código).
- `private`: Garante o encapsulamento, permitindo que apenas a própria ViewModel altere ou acesse certas propriedades e métodos (explicado na primeira ocorrência em comentários no código).

## Propriedades
- `@Published var currentRating: Float` – Avaliação atual exibida no cartão do destino. Usando @Published pois permite que SwiftUI atualize a interface automaticamente quando o valor muda.
- `@Published var enrichedData: EnrichedDestinationModel?` – Dados enriquecidos sobre o destino (clima, tempo de viagem, etc).
- `@Published var isLoadingEnrichment: Bool` – Indica se o enriquecimento dos dados está em andamento.
- `@Published var selectedPhotoIndex: Int` – Índice da foto selecionada para exibição.
- `@Published var additionalWeatherConditions: [AdditionalWeatherCondition]` – Condições climáticas adicionais para exibir no cartão.
- `@Published var weatherRecommendations: [WeatherRecommendation]` – Recomendações baseadas no clima atual.
- `@Published var isFavorited: Bool` – Indica se o destino está marcado como favorito.
- `private let destination: TravelDestination` – Destino de viagem que esta ViewModel representa. O uso de private garante encapsulamento.
- `private let apiService: TransportAPIServiceProtocol` – Serviço para chamadas à API de transporte.
- `private let weatherService: WeatherServiceProtocol` – Serviço para obter dados e lógica relacionados ao clima.
- `private var cancellables = Set<AnyCancellable>()` – Conjunto para armazenar assinaturas Combine.
- `private let favoritesService = FavoritesService.shared` – Serviço usado para persistir e consultar favoritos.

## Métodos principais
- `init(...)` – Inicializa o ViewModel, definindo suas dependências e configurando observadores de clima.
- `func loadEnrichedData() async` – Carrega e atualiza dados enriquecidos para o destino, incluindo clima e tempo de viagem. Atualiza propriedades relacionadas ao clima e recomendações. Deve ser chamado de forma assíncrona.
- `func toggleFavorite()` – Alterna o status de favorito do destino, salvando ou removendo dos favoritos persistidos. Dispara feedback háptico ao adicionar aos favoritos.
- `func getFavoriteAction() -> (() -> Void)` – Retorna uma closure que alterna o status favorito ao ser chamada.
- `func shareDestination() -> [Any]` – Prepara uma lista de itens para compartilhamento do destino, incluindo notas e clima se disponível.
- `func shareWithWeather() -> String?` – Prepara uma mensagem de texto para compartilhar o destino junto com as informações de clima.
- `func getShareAction() -> (() -> Void)` – Retorna uma closure que executa o compartilhamento padrão.
- `func getShareWithWeatherAction() -> (() -> Void)` – Retorna uma closure que compartilha com informações de clima.
- `func weatherColor(for condition: String) -> Color` – Retorna a cor UI adequada para a condição climática informada.
- `func weatherIcon(for condition: String, isDay: Bool = true) -> String` – Retorna o nome do ícone SF Symbol correspondente à condição climática.
## Métodos privados
- `private func setupWeatherObservers()` – Observa mudanças em enrichedData e atualiza condições e recomendações climáticas. O uso de private garante que apenas a ViewModel controla essa lógica.
- `private func updateWeatherData(for weather: WeatherDataModel?)` – Atualiza condições e recomendações climáticas usando os serviços apropriados.
- `private func updateWeatherConditions(for condition: String)` – Atualiza condições adicionais de clima.
- `private func updateWeatherRecommendations(for weather: WeatherDataModel)` – Atualiza recomendações baseadas no clima.
- `private func prepareShareItems() -> [Any]` – Monta os itens para compartilhamento.
- `private func prepareWeatherShareMessage(weather: WeatherDataModel) -> String` – Monta mensagem de compartilhamento com informações de clima.
- `private func presentShareSheet(items: [Any])` – Apresenta o share sheet nativo no iOS.

---

