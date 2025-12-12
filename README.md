# IMDUMB-APP
IMDUMB es una app iOS que muestra categorías de películas y el detalle de cada película.  
El objetivo del reto es evaluar arquitectura (MVP + Clean), consumo de APIs con Alamofire, uso de Firebase y buenas prácticas.

## 🧱 Tech Stack

- iOS (UIKit, Storyboards + XIBs)
- Arquitectura: MVP + Clean Architecture (Domain / Data / Presentation)
- Swift Package Manager
  - Alamofire (5.x)
  - Firebase (Remote Config / Realtime Database)
- Persistencia local: UserDefaults (cache simple de categorías, opcional)
- Mocks: DataStores de red y local mockeados

## 🚀 Cómo correr el proyecto

1. `git clone https://github.com/tuusuario/IMDUMB.git`
2. Abrir `IMDUMB.xcodeproj` en **Xcode 16.x**.
3. Seleccionar el scheme:
   - `IMDUMB-Dev` o `IMDUMB-Prod`
4. Configurar Firebase:
   - Crear proyecto en Firebase.
   - Descargar el `GoogleService-Info.plist` correspondiente a cada target.
   - Arrastrar cada plist al target que corresponda.
5. Compilar y correr en un simulador iOS 17+.

## 🌐 Endpoints

Actualmente la app consume:

- `GET /categories` → Lista de categorías con películas
- `GET /movies/{id}` → Detalle de película

> Si no se tiene un backend real, se puede usar `MovieMockDataStore` activando el flag `USE_MOCKS = true` en `DependencyContainer`.

## 🧩 Arquitectura

La app está separada en 3 capas principales:

Domain
Data 
Presentation


## 🧪 Mocks

Para pruebas manuales:
- `MovieMockDataStore` devuelve datos estáticos.
- Cambia la inyección en `DependencyContainer` para usar `MovieMockDataStore` en lugar de `MovieRemoteDataStore`.

## 📚 SOLID

Ejemplos documentados en el código:

1. **SRP (Single Responsibility Principle)**
   - `SplashPresenter`: solo coordina la lógica de la pantalla de Splash.
   - Ver archivo: `Presentation/Modules/Splash/SplashPresenter.swift`

2. **OCP (Open/Closed Principle)**
   - `AppConfiguration`: permite agregar nuevos ambientes sin modificar el comportamiento de los consumidores.
   - Ver archivo: `App/Application/AppConfiguration.swift`

3. **DIP (Dependency Inversion Principle)**
   - Presenters dependen de protocolos (`MovieRepository`, `FetchCategoriesUseCaseProtocol`) en lugar de implementaciones concretas.
   - Ver archivo: `Domain/UseCases/FetchCategoriesUseCase.swift` y `Presentation/Modules/Categories/CategoriesPresenter.swift`

Los comentarios en el código marcan explícitamente dónde se aplica cada principio.
