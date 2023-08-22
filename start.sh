#!/bin/sh

# Проверяем значение переменной DEBUG
if [ "$DEBUG" = "1" ]; then
    /dlv --listen=:40000 --headless=true --api-version=2 --accept-multiclient --check-go-version=false exec /main
    # Здесь можно выполнить команду A
else
    /main
    # Здесь можно выполнить команду B
fi