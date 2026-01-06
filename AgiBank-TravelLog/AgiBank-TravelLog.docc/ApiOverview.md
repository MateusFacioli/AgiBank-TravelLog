# API Overview

Bem-vindo à documentação de API do AgiBank-TravelLog. Esta página reúne a visão geral das principais APIs, serviços e view models do projeto e fornece exemplos de uso e links (referências) para as implementações.

## Sumário

- Sobre
- Principais componentes
  - ViewModels
  - Serviços / Camada de Dados
  - Cliente HTTP / Endpoints
  - Modelos de Erro
- Exemplos de uso
- Como gerar a documentação localmente

---

## Sobre

Esta documentação explica as interfaces públicas e os fluxos principais usados no app TravelLog: carregamento de destinos, enriquecimento de dados externos (clima, fotos, avaliações), favoritos do usuário e comunicação com backend.

Use as seções abaixo para navegar rapidamente até a API que precisa.

---

## Principais componentes

### ViewModels

- `TravelViewModel`  
  Gerencia a lista de destinos, seleção por categoria, carregamento assíncrono e captura de erros.  
  Operações principais:
  - `loadDestinations()` — carrega destinos de forma assíncrona.
  - `addDestination(_:)` — adiciona e recarrega a lista.
  - `filteredDestinations` — retorno filtrado por categoria.

- `FavoritesViewModel`  
  Gerencia os destinos favoritos do usuário (lista reativa com @Published).  
  Operações principais:
  - `loadFavorites()` — carrega do serviço de favoritos.
  - `toggleFavorite(for:)` — alterna favorito.
  - `isFavorite(_:)` — verifica estado.

- `AuthViewModel` (documentado em outro lugar)  
  Encapsula autenticação (signIn, createUser, sendPasswordReset, signOut) — usa FirebaseAuth quando disponível.

### Serviços / Camada de Dados

- `TravelService` / `TravelRepository`  
  Interfaces/implementações que encapsulam regras de negócio e delegam para `APIClient` para operações de rede.

- `FavoritesService`  
  Singleton que persiste IDs de favoritos em `UserDefaults`:
  - `isFavorite(destinationId:)`
  - `addFavorite(destinationId:)`
  - `removeFavorite(destinationId:)`
  - `toggleFavorite(destinationId:)`
  - `getAllFavorites()`
  - `clearAllFavorites()`

- `TransportAPIService`  
  Serviço que agrega múltiplas fontes externas para enriquecer um destino:
  - `enrichDestination(_:)` — combina OpenWeather, Unsplash, Google Places, Directions etc.
  - `getCachedData(for:)`, `cacheData(_:for:)` — caching com `NSCache`.

- `WeatherService`  
  Utilitário para mapear condição textual de clima em cores, ícones e recomendações.

### Cliente HTTP / Endpoints

- `APIEndpoint`  
  Enum com os endpoints e métodos HTTP:
  - `.destinations` (GET)
  - `.saveDestination(TravelDestination)` (POST)
  - `.uploadImage(Data)` (POST)

- `APIClient`  
  Actor que faz requisições `async/await`, decodifica respostas e lança `APIError` em cenários de falha:
  - `request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T`
  - `request(_ endpoint: APIEndpoint) async throws` (sem retorno)
  - `upload(data:) async throws -> URL` (placeholder)

### Modelos de erro

- `APIError`  
  Enum extensivo com mapeamentos para códigos HTTP, mensagens legíveis (`errorDescription`), sugestões de recuperação (`recoverySuggestion`) e utilitários (`isNetworkError`, `isAuthenticationError`, etc).  
  Método utilitário:
  - `APIError.from(statusCode: Int, message: String?)`
  - `APIError.from(error: Error)`

---

## Exemplos de uso

Exemplo simples — carregar destinos em uma `View` usando `TravelViewModel`:

```swift
@StateObject private var vm = TravelViewModel()

var body: some View {
    List(vm.filteredDestinations) { dest in
        Text(dest.name)
    }
    .task {
        await vm.loadDestinations()
    }
}
```

Exemplo — usar `APIClient` para buscar manualmente destinos:

```swift
let client = APIClient()
Task {
    do {
        let destinations: [TravelDestination] = try await client.request(.destinations)
        print("Found: \(destinations.count)")
    } catch {
        let apiError = APIError.from(error: error)
        print("Erro: \(apiError.errorDescription ?? \"\")")
    }
}
```

Exemplo — alternar favorito:

```swift
let service = FavoritesService.shared
let id = someDestination.id
let isNowFavorite = service.toggleFavorite(destinationId: id)
```

---

## Relações e responsabilidades

- `ViewModels` são responsáveis por expor estado para a UI e por orquestrar chamadas para `Service` / `Repository`.
- `Services` encapsulam lógica de persistência e integrações com APIs externas.
- `APIClient` é a camada única de rede e normaliza o tratamento de erros em `APIError`.

---

## Links rápidos (arquivos no código)

- `TravelViewModel` — `TravelViewModel.swift`  
- `FavoritesService` — `FavoritesService.swift`  
- `TransportAPIService` — `TransportAPIService.swift`  
- `APIClient`, `APIEndpoint` — `APIEndpoint.swift`  
- `APIError` — `APIError.swift`  
- `TravelService` — `TravelService.swift`  
- `WeatherService` — `WeatherService.swift`
