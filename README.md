# 🖥️ Server Monitoring Dashboard

Легковесная система мониторинга серверов с автоматизацией через **Ansible** и веб-интерфейсом. Отслеживание CPU, RAM, Disk, Network в реальном времени с уведомлениями в Telegram.

## 📋 Описание

Комплексное решение для мониторинга серверов, состоящее из:

- **Ansible Automation** - автоматизированный сбор метрик через playbooks
- **Monitoring Scripts** - bash-скрипты для проверки ресурсов и сайтов
- **JSON API** - метрики в формате JSON для интеграции с любыми системами
- **Telegram Notifications** - уведомления о статусе сервера

## ✨ Особенности

- ✅ **Автоматизация через Ansible** - один playbook для настройки всего
- ✅ **Интеграция с Semaphore** - веб-интерфейс для управления задачами
- ✅ **Telegram уведомления** - мгновенные алерты о проблемах
- ✅ **JSON API** - готовые метрики для интеграции
- ✅ **Легковесность** - минимальные зависимости, работает на любом Linux
- ✅ **Production-ready** - протестировано на реальных серверах

## 🗂️ Структура проекта

```
server-monitoring/
├── README.md                 # Этот файл
├── ansible/                  # Ansible automation
│   ├── playbooks/           # Playbooks для мониторинга
│   ├── roles/               # Ansible роли
│   │   └── monitoring/      # Роль мониторинга
│   ├── inventories/         # Примеры inventory
│   ├── semaphore/           # Docker compose для Semaphore
│   └── docs/                # Документация по Ansible
├── scripts/                  # Bash скрипты мониторинга
│   └── check_website_json.sh
└── docs/                     # Общая документация (планируется)
```

## 🚀 Быстрый старт

### Требования

- Linux сервер (Ubuntu 20.04+, CentOS 7+, Debian 10+)
- Ansible 2.15+ (на управляющем хосте)
- Python 3.8+ (на целевом сервере)
- SSH доступ к серверу

### Установка через Ansible

```bash
# 1. Клонируйте репозиторий
git clone https://github.com/Airat71/server-monitoring.git
cd server-monitoring

# 2. Настройте inventory
cp ansible/inventories/example.ini ansible/inventories/prod.ini
# Отредактируйте prod.ini с вашими данными сервера

# 3. Запустите playbook
ansible-playbook -i ansible/inventories/prod.ini ansible/monitoring.yml
```

### Ручная установка скриптов

```bash
# Скопируйте скрипты на сервер
scp scripts/check_website_json.sh user@server:/srv/projects/monitoring/scripts/

# Дайте права на выполнение
ssh user@server "chmod +x /srv/projects/monitoring/scripts/check_website_json.sh"
```

## 📊 Что мониторится

### Системные метрики

- **CPU** - использование процессора (%)
- **RAM** - использование оперативной памяти (%)
- **Disk** - использование дискового пространства (%)
- **Network** - сетевой трафик (опционально)

### Проверка сайтов

- **HTTP Status** - код ответа сервера
- **Response Time** - время отклика
- **Availability** - доступность сайта (UP/DOWN)

## 📈 Формат данных

Метрики сохраняются в JSON формате:

### data.json

```json
{
  "timestamp": "2025-11-13T12:00:00+00:00",
  "cpu": {
    "usage": 4.5,
    "status": "OK"
  },
  "ram": {
    "usage": 14.8,
    "used": "578Mi",
    "total": "3.8Gi",
    "status": "OK"
  },
  "disk": {
    "usage": 29,
    "used": "11G",
    "total": "38G",
    "status": "OK"
  }
}
```

### website_status.json

```json
{
  "timestamp": "2025-11-13T12:00:00+00:00",
  "website": "https://example.com",
  "status": "UP",
  "http_code": "200",
  "message": "Website is accessible"
}
```

## 🔧 Настройка

### Переменные Ansible

Основные переменные настраиваются в `ansible/roles/monitoring/defaults/main.yml`:

```yaml
monitoring_dir: "/srv/projects/monitoring"
monitoring_website_url: "https://example.com"
monitoring_cpu_warning: 70
monitoring_cpu_critical: 90
# ... и другие
```

### Telegram уведомления

Настройте Telegram бота в `ansible/semaphore/docker-compose.example.yml`:

```yaml
TELEGRAM_BOT_TOKEN: "YOUR_TELEGRAM_BOT_TOKEN_HERE"
```

## 📚 Документация

- [Ansible Setup](ansible/README.md) - настройка Ansible automation
- [Semaphore Setup](ansible/docs/SEMAPHORE_SETUP.md) - установка Semaphore
- [Semaphore Config](ansible/docs/SEMAPHORE_CONFIG.md) - конфигурация Semaphore
- [Deployment Guide](scripts/DEPLOY.md) - инструкция по развертыванию

## 🔄 Автоматизация

### Через Ansible Semaphore

1. Установите Semaphore (см. [документацию](ansible/docs/SEMAPHORE_SETUP.md))
2. Создайте проект и inventory в Semaphore
3. Настройте шаблон задачи
4. Запускайте playbook через веб-интерфейс

### Через Cron

```bash
# Добавьте в crontab на сервере
*/5 * * * * /srv/projects/monitoring/scripts/check_website_json.sh
```

## 🛠️ Технологии

- **Ansible** - автоматизация инфраструктуры
- **Bash** - скрипты мониторинга
- **Docker** - контейнеризация Semaphore
- **Telegram Bot API** - уведомления
- **JSON** - формат данных

## 📝 Лицензия

MIT License - см. файл [LICENSE](LICENSE)

## ✨ Автор

**Айрат** - Системный администратор

- GitHub: [@Airat71](https://github.com/Airat71)

## 🙏 Благодарности

- Ansible Community
- Semaphore Project
- Linux Community

---

⭐ Если этот проект оказался полезен, поставьте звезду!

