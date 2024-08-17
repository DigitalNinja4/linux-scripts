#!/bin/sh

# Upewnij się, że jesteś rootem
if [ "$(id -u)" -ne 0 ]; then
  echo "Ten skrypt musi być uruchomiony z uprawnieniami roota."
  exit 1
fi

# Sprawdzenie, czy podano wersję jako argument
if [ -z "$1" ]; then
  echo "Nie podano wersji Alpine Linux. Użycie: $0 <wersja>"
  exit 1
fi

# Przypisanie wersji z argumentu
NEW_VERSION=$1

echo "Wybrana wersja Alpine Linux: $NEW_VERSION"

# Sprawdzenie, czy podana wersja jest poprawna
if ! wget -q --spider http://dl-cdn.alpinelinux.org/alpine/v$NEW_VERSION/main/x86_64/; then
  echo "Podana wersja Alpine Linux ($NEW_VERSION) nie istnieje lub nie jest dostępna w repozytoriach."
  exit 1
fi

# Zaktualizuj repozytoria do podanej wersji
echo "Aktualizacja repozytoriów do Alpine Linux v$NEW_VERSION..."
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

echo "Aktualizacja systemu do wersji $NEW_VERSION zakończona pomyślnie."

# Informacja o potrzebie ponownego uruchomienia systemu
echo "Jeśli jądro zostało zaktualizowane, zaleca się ponowne uruchomienie systemu."
