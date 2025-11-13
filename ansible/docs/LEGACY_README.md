# Ansible Server Monitoring

> ⚠️ Этот файл описывает старую структуру проекта `ansible-monitoring`. Актуальная рабочая директория — `ansible/`, входной playbook находится в корне репозитория (`monitoring.yml`).

Автоматизированный мониторинг сервера с использованием Ansible.

## 📋 Описание

Ansible playbook для мониторинга сервера, который собирает метрики:
- **CPU** - использование процессора
- **RAM** - использование оперативной памяти  
- **Disk** - использование дискового пространства
- **Website** - статус доступности сайта

Результаты сохраняются в JSON файлы для дальнейшего использования.

## 🗂️ Структура проекта

```
ansible-monitoring/
├── inventory.ini      # Инвентарь серверов
├── monitoring.yml     # Основной playbook
└── README.md          # Документация
```

## 🚀 Установка Ansible

### На Mac (через Homebrew)

```bash
brew install ansible
```

### На Ubuntu/Debian

```bash
sudo apt update
sudo apt install -y ansible
```

### Проверка установки

```bash
ansible --version
```

## ⚙️ Настройка

### 1. Настройка inventory

Отредактируйте `inventory.ini`:

```ini
[servers]
server-example ansible_host=192.168.1.100 ansible_user=your_username ansible_port=22

[servers:vars]
ansible_ssh_private_key_file=~/.ssh/id_rsa
ansible_python_interpreter=/usr/bin/python3
```

### 2. Настройка SSH ключей

Убедитесь, что SSH ключи настроены:

```bash
# Проверка подключения
ssh your_username@your-server-ip

# Если нужно, добавьте ключ
ssh-copy-id your_username@your-server-ip
```

## 🎯 Использование

### Запуск мониторинга

```bash
# Из директории проекта
cd ansible-monitoring

# Запуск playbook
ansible-playbook -i inventory.ini monitoring.yml
```

### Запуск с выводом подробной информации

```bash
ansible-playbook -i inventory.ini monitoring.yml -v
```

### Запуск для конкретного сервера

```bash
ansible-playbook -i inventory.ini monitoring.yml --limit server-xleyyo
```

## 📊 Результаты

После выполнения playbook создаются:

1. **JSON файлы** в `/srv/projects/monitoring/dashboard/`:
   - `data.json` - метрики ресурсов (CPU, RAM, Disk)
   - `website_status.json` - статус сайта

2. **Логи** в `/srv/projects/monitoring/logs/`:
   - `monitoring.log` - история мониторинга

## 📝 Формат данных

### data.json

```json
{
  "timestamp": "2025-11-06T13:19:23+00:00",
  "cpu": {
    "usage": 4.8,
    "status": "OK"
  },
  "ram": {
    "usage": 14.8,
    "used": "579Mi",
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
  "timestamp": "2025-11-06T13:19:23+00:00",
  "website": "https://example.com",
  "status": "UP",
  "http_code": "200",
  "message": "Website is accessible"
}
```

## 🔧 Настройка порогов

Пороги для статусов настраиваются в `monitoring.yml`:

- **CPU**: OK < 70%, WARNING 70-90%, CRITICAL > 90%
- **RAM**: OK < 80%, WARNING 80-90%, CRITICAL > 90%
- **Disk**: OK < 80%, WARNING 80-90%, CRITICAL > 90%

## ⏰ Автоматизация через Cron

Добавьте в crontab для автоматического запуска:

```bash
crontab -e
```

Добавьте строку:

```
# Мониторинг каждые 5 минут
*/5 * * * * cd /Users/airat/github-projects && ansible-playbook -i ansible/inventories/servers.ini ansible/monitoring.yml > /dev/null 2>&1
```