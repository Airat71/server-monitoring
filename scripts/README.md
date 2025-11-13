# Monitoring Scripts

Bash-скрипты для мониторинга сервера и проверки доступности сайтов. Эти скрипты используются совместно с [Ansible monitoring role](../ansible/) для автоматизации сбора метрик.

## 📋 Описание

Набор скриптов для:
- Проверки доступности веб-сайтов
- Генерации JSON файлов для дашбордов
- Интеграции с системами мониторинга

## 📂 Скрипты

- `check_website_json.sh` - Проверка доступности сайта с генерацией JSON

## 🚀 Использование

### Проверка доступности сайта

```bash
# Запуск скрипта
./check_website_json.sh

# Скрипт создаст JSON файл:
# /srv/projects/monitoring/dashboard/website_status.json
```

### Формат выходного JSON

```json
{
  "timestamp": "2025-11-13T12:00:00+00:00",
  "website": "https://example.com",
  "status": "UP",
  "http_code": "200",
  "message": "Website is accessible"
}
```

## ⚙️ Настройка

Отредактируйте переменные в начале скрипта:

```bash
WEBSITE="https://your-website.com"  # URL для проверки
JSON_FILE="/srv/projects/monitoring/dashboard/website_status.json"  # Путь к выходному файлу
TIMEOUT=10  # Таймаут проверки в секундах
```

## 🔄 Автоматизация

Добавьте в crontab для автоматической проверки:

```bash
# Проверка сайта каждые 5 минут
*/5 * * * * /srv/projects/monitoring/scripts/check_website_json.sh > /dev/null 2>&1
```

## 📝 Требования

- Bash 4.0+
- `curl` для проверки HTTP
- Права на запись в директорию для JSON файлов

## 🔗 Связанные проекты

- [Ansible Monitoring Role](../ansible/) - автоматизация мониторинга через Ansible
- [Main README](../README.md) - общая документация проекта

