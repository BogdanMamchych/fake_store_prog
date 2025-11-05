# fake_store_prog

# Fake Store (Mock Store)

**Fake Store** — a Flutter application that demonstrates working with a fake e-commerce API ([https://fakestoreapi.com](https://fakestoreapi.com)).
The app supports authentication, browsing products, viewing product details, managing a shopping cart, and placing orders. This `README.md` is ready to paste into your repository.

---

## Table of contents

* [Features](#features)
* [Requirements](#requirements)
* [Quick start](#quick-start)

  * [Install dependencies](#install-dependencies)
  * [Run the app](#run-the-app)
  * [Build release APK (optional)](#build-release-apk-optional)
* [Configuration](#configuration)
* [Example usage / behavior](#example-usage--behavior)

  * [Authentication flow (example)](#authentication-flow-example)
  * [Checkout (example)](#checkout-example)
* [Project structure](#project-structure)
* [Notes on architecture](#notes-on-architecture)

---

## Features

* User authentication (login) via `/auth/login` endpoint.
* Product listing fetched from `/products` with pagination (5 items per page).
* Product detail page with description and rating.
* Shopping cart: add items, change quantities, remove items (swipe), and view total price.
* Checkout: submit cart to `/carts` (POST) and clear local cart on success.
* State management implemented with **BLoC** (flutter_bloc).
* Dependency injection with **GetIt / Injectable**.
* Network communication via **Dio**.

---

## Requirements

* Flutter SDK (recommended: Flutter 3.x or later)
* Dart >= 2.17
* A connected device or emulator to run the app

Common pub packages used in the project (ensure included in `pubspec.yaml`):

* `flutter_bloc`
* `dio`
* `get_it`
* `injectable`
* `go_router`
* `jwt_decoder` (or similar)
* `shared_preferences` / `flutter_secure_storage`

---

## Quick start

### Install dependencies

From the project root run:

```bash
flutter pub get
```

### Run the app

Start an emulator or connect a device, then:

```bash
flutter run
```

This will compile and run the app. The default flow:

1. **Welcome** screen with *Get Started* button.
2. Tap *Get Started* → **Login** screen.
3. Enter username & password → tap *Login*. On success you land on the **Home** screen with product listings.
4. Tap a product → **Product page** with details and an **Add to cart** button.
5. Open **Cart** via bottom navigation → modify quantities or proceed to **Checkout**.

### Build release APK (optional)

```bash
flutter build apk --release
```

---

## Configuration

The app expects to communicate with a Fake Store API (default: `https://fakestoreapi.com`). If the base URL is configurable in your project, set it in the appropriate config file or constant (for example, `AppConstants.apiBaseUrl`).

If you store secrets or tokens locally, the app uses secure/local storage (e.g., `flutter_secure_storage` or `shared_preferences`) to keep authentication tokens.

---

## Example usage / behavior

### Authentication flow (example)

* Endpoint: `POST https://fakestoreapi.com/auth/login`
* Request body (JSON):

  ```json
  {
    "username": "someUser",
    "password": "somePass"
  }
  ```
* Expected behavior:

  * On success, API returns a token (JWT or string).
  * App stores token and navigates to Home screen.
  * Header shows greeting (e.g., "Hello, <username>") and a Logout button.

### Checkout (example)

* Endpoint: `POST https://fakestoreapi.com/carts`
* Request body (example JSON):

  ```json
  {
    "userId": 1,
    "date": "2024-01-01",
    "products": [
      { "productId": 3, "quantity": 2 },
      { "productId": 5, "quantity": 1 }
    ]
  }
  ```
* Expected behavior:

  * On success, app clears the local cart and shows a confirmation (SnackBar/dialog).
  * On failure, app shows error message and preserves cart contents.

---

## Project structure (high-level)

```
lib/
├─ main.dart                  # App entry point, DI bootstrap, MaterialApp setup
├─ app_router.dart            # App routes (GoRouter)
├─ core/
│  ├─ api/                    # API client (Dio), endpoints
│  ├─ models/                 # Data models (Item, CartItem, User, etc.)
│  ├─ repositories/           # Repository interfaces + implementations
│  ├─ local/                  # Constants, exceptions, preferences
│  ├─ usecases/               # Business logic (use cases)
│  ├─ helpers/                # Utility functions (jwt helper, findCartItem)
│  └─ widgets/                # Shared widgets (Header, BottomNavBar, Buttons)
├─ di/                        # Dependency injection (GetIt, Injectable)
└─ features/
   ├─ auth/
   │  ├─ data/
   │  ├─ domain/
   │  └─ presentation/        # AuthBloc, LoginPage, WelcomePage
   ├─ item_list/
   │  └─ presentation/        # ItemListBloc, HomePage, ItemCard
   ├─ item_viewer/
   │  └─ presentation/        # ItemViewerBloc, ItemPage
   └─ cart/
      ├─ data/
      ├─ domain/
      └─ presentation/        # CartBloc, CartPage
assets/                       # Images, fonts, styles (optional)
pubspec.yaml
```

Each feature follows a layered approach: **data → domain → presentation**. This keeps networking and local storage separated from business logic and UI.

---

## Notes on architecture

* **BLoC (flutter_bloc)**: blocs handle events and emit states; UI subscribes to states.
* **Repositories & DataSources**: repositories orchestrate data fetching from remote (API) and local sources.
* **Use Cases**: single-responsibility classes encapsulating business rules (add-to-cart, confirm-order, etc.).
* **DI**: GetIt and Injectable register singletons and factories for easy testing and loose coupling.

