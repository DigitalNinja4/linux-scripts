#!/bin/sh

# Upewnij się, że jesteś rootem
if [ "$(id -u)" -ne 0 ]; then
  echo "Ten skrypt musi być uruchomiony z uprawnieniami roota."
  exit 1
fi

# Pobierz najnowszą wersję Alpine Linux z repozytorium
echo "Sprawdzanie najnowszej wersji Alpine Linux..."
NEW_VERSION=$(wget -qO- http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/x86_64/latest-releases.yaml | grep -oP '(?<=version: )\d+\.\d+' | sort -V | tail -1)

if [ -z "$NEW_VERSION" ]; then
  echo "Nie udało się ustalić najnowszej wersji Alpine Linux."
  exit 1
fi

echo "Najnowsza wersja Alpine Linux: $NEW_VERSION"

# Zaktualizuj repozytoria do najnowszej wersji
echo "Aktualizacja repozytoriów do Alpine Linux $NEW_VERSION..."
sed -i "s|/v[0-9]\+\.[0-9]\+/|/v$NEW_VERSION/|g" /etc/apk/repositories

# Aktualizuj indeksy pakietów
echo "Aktualizacja indeksów pakietów..."
apk update

# Uaktualnij wszystkie zainstalowane pakiety
echo "Aktualizacja zainstalowanych pakietów..."
apk upgrade --available

# Aktualizacja plików konfiguracyjnych
echo "Aktualizacja plików konfiguracyjnych..."
apk fix

# Sprawdź, czy są dostępne nowe wersje jądra i aktualizuj, jeśli są dostępne
if apk search -e linux-lts | grep -q '^linux-lts-'; then
  echo "Aktualizacja jądra Linux..."
  apk upgrade linux-lts
fi

# Wyczyść nieużywane pliki pakietów i tymczasowe pliki
echo "Czyszczenie systemu..."
apk cache clean

echo "Aktualizacja systemu zakończona pomyślnie."

# Informacja o potrzebie ponownego uruchomienia systemu
echo "Jeśli jądro zostało zaktualizowane, zaleca się ponowne uruchomienie systemu."
