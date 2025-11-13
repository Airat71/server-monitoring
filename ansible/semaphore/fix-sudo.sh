#!/bin/bash
# Скрипт для настройки sudo без пароля для пользователя

echo "your_username ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/your_username
sudo chmod 0440 /etc/sudoers.d/your_username
sudo visudo -c

echo "Проверка sudo без пароля через SSH:"
ssh your_username@your-server-ip "sudo -n whoami" && echo "✅ Sudo работает без пароля!" || echo "❌ Sudo всё ещё запрашивает пароль"

