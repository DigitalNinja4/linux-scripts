#!/bin/sh

# Upewnij się, że jesteś rootem
if [ "$(id -u)" -ne 0 ]; then
  echo "Ten skrypt musi być uruchomiony z uprawnieniami roota."
  exit 1
fi

# Aktualizuj indeksy pakietów
echo "Aktualizacja indeksów pakietów..."
apk update

# Instalacja Dockera
echo "Instalacja Dockera..."
apk add docker

# Uruchomienie Dockera przy starcie systemu
echo "Konfigurowanie Dockera do uruchamiania przy starcie systemu..."
rc-update add docker boot

# Uruchomienie usługi Docker
echo "Uruchamianie usługi Docker..."
service docker start

# Sprawdzenie wersji Dockera (opcjonalnie)
echo "Zainstalowana wersja Dockera:"
docker --version

# Instalacja Docker Compose (zainstaluje Compose v2 jako wtyczkę Docker)
echo "Instalacja Docker Compose..."
apk add docker-compose-plugin

# Sprawdzenie wersji Docker Compose (opcjonalnie)
echo "Zainstalowana wersja Docker Compose:"
docker compose version

echo "Instalacja Dockera i Docker Compose zakończona pomyślnie."
