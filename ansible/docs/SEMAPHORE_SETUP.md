# Установка Ansible Semaphore

Веб-интерфейс для управления Ansible playbook.

## 📋 Описание

Ansible Semaphore - это веб-интерфейс для управления Ansible, который позволяет:
- Запускать playbook через браузер
- Планировать автоматические задачи
- Просматривать историю выполнения
- Управлять инвентарями
- Просматривать логи и результаты

## 🚀 Установка через Docker

### Предварительные требования

- Docker установлен на вашем Mac
- Ansible установлен (уже установлен)

### Установка Docker (если не установлен)

```bash
# Установка Docker Desktop для Mac
brew install --cask docker

# Или скачайте с официального сайта
# https://www.docker.com/products/docker-desktop
```

### Запуск Semaphore

```bash
# Создайте директорию для данных Semaphore
mkdir -p ~/ansible-semaphore-data

# Запустите Semaphore через Docker
docker run -d \
  --name ansible-semaphore \
  -p 3000:3000 \
  -v ~/ansible-semaphore-data:/data \
  -v /Users/airat/github-projects/ansible:/ansible \
  ansiblesemaphore/semaphore:latest
```

### Проверка запуска

```bash
# Проверка что контейнер запущен
docker ps | grep semaphore

# Просмотр логов
docker logs ansible-semaphore
```

## 🌐 Первый запуск

1. Откройте браузер: `http://localhost:3000`
2. Создайте администратора:
   - Email: ваш email
   - Пароль: придумайте пароль
   - Имя: ваше имя

## ⚙️ Настройка проекта

### 1. Создание проекта

1. Войдите в Semaphore
2. Нажмите "New Project"
3. Название: "Server Monitoring"
4. Нажмите "Create"

### 2. Настройка инвентаря

1. Перейдите в "Inventory"
2. Нажмите "New Inventory"
3. Название: "servers"
4. Тип: "Static"
5. Вставьте содержимое `inventory.ini`:

```ini
[servers]
server-example ansible_host=192.168.1.100 ansible_user=your_username ansible_port=22

[servers:vars]
ansible_ssh_private_key_file=/ansible/.ssh/id_rsa
ansible_python_interpreter=/usr/bin/python3
ansible_become=yes
ansible_become_method=sudo
ansible_become_user=root
```

6. Сохраните

### 3. Настройка ключей SSH

```bash
# Скопируйте SSH ключ в контейнер
docker cp ~/.ssh/id_rsa ansible-semaphore:/ansible/.ssh/
docker cp ~/.ssh/id_rsa.pub ansible-semaphore:/ansible/.ssh/

# Установите права
docker exec ansible-semaphore chmod 600 /ansible/.ssh/id_rsa
```

### 4. Создание шаблона задачи

1. Перейдите в "Templates"
2. Нажмите "New Template"
3. Настройки:
   - Название: "Server Monitoring"
   - Инвентарь: выберите "servers"
   - Playbook: `/ansible/monitoring.yml`
   - Описание: "Мониторинг сервера"
   - Примечание: входной файл лежит в корне репозитория и импортирует `ansible/playbooks/monitoring.yml`
4. Сохраните

## 🎯 Запуск задачи

1. Перейдите в "Templates"
2. Нажмите на созданный шаблон
3. Нажмите "Run"
4. Следите за выполнением в реальном времени

## 📊 Просмотр результатов

1. Перейдите в "Tasks"
2. Выберите выполненную задачу
3. Просмотрите логи и результаты

## ⏰ Планирование задач

1. Перейдите в "Templates"
2. Выберите шаблон
3. Нажмите "Schedule"
4. Настройте расписание (например, каждые 5 минут)
5. Сохраните

## 🔧 Управление контейнером

```bash
# Остановка
docker stop ansible-semaphore

# Запуск
docker start ansible-semaphore

# Перезапуск
docker restart ansible-semaphore

# Удаление
docker stop ansible-semaphore
docker rm ansible-semaphore

# Просмотр логов
docker logs -f ansible-semaphore
```

## 🔒 Безопасность

- Используйте сильный пароль для администратора
- Не открывайте порт 3000 в интернет без защиты
- Регулярно обновляйте Docker образ

## 📚 Дополнительная информация

- [Официальная документация Semaphore](https://ansible-semaphore.com/)
- [GitHub репозиторий](https://github.com/ansible-semaphore/semaphore)

## ⚠️ Решение проблем

### Проблема: Контейнер не запускается

```bash
# Проверьте логи
docker logs ansible-semaphore

# Проверьте что порт 3000 свободен
lsof -i :3000
```

### Проблема: Не могу подключиться к серверу

```bash
# Проверьте SSH ключ в контейнере
docker exec ansible-semaphore ls -la /ansible/.ssh/

# Проверьте подключение из контейнера
docker exec ansible-semaphore ssh -i /ansible/.ssh/id_rsa your_username@your-server-ip "whoami"
```

### Проблема: Playbook не находит файлы

Убедитесь что путь к playbook правильный: `/ansible/monitoring.yml`

