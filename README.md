# Systemize POS

**Systemize POS** is a restaurant Point of Sale (POS) system built using **Flutter** and **BLoC** architecture. It’s optimized for local network operation with full offline capabilities and automatic real-time data synchronization to the server using **WebSockets**.

## 🧩 Key Features

- 🍽️ **Restaurant-specific workflows**: Supports Dine In, Take Away, and Delivery.
- 💾 **Offline-first architecture**: Stores all data locally using SharedPreferences and local database.
- 🔄 **WebSocket Sync**: Automatically syncs with the server when connected to the internet.
- 🛜 **Local Network Support**: Fully functional over LAN even without internet access.
- 🖨️ **Local Printing**: Supports printing invoices and KOTs via local network printers.
- 🧠 **BLoC Pattern**: Scalable and testable business logic using the BLoC architecture.
- 🧑‍🍳 **Staff & Table Assignment**: Assign waiters, select tables, manage customer info.
- 🧺 **Advanced Cart System**: Handle product variations, add-ons, and real-time cart updates.
- 📋 **Order History & Hold Orders**: Temporarily hold and resume orders for multitasking.

## 🛠️ Built With

- **Flutter** - UI development
- **BLoC (flutter_bloc)** - State management
- **SharedPreferences** - Local key-value storage
- **WebSockets** - Real-time server communication
- **REST API** - For initial config/data fetch
- **GetIt** or **Injectable**  - Dependency injection 

## 🌐 Use Case

Systemize POS is perfect for:

- Restaurants
- Cafés
- Cloud Kitchens
- Food Trucks

that need a **reliable, fast, and network-independent POS** system that syncs when connectivity is restored.