# Пошаговая настройка Semaphore

Инструкция по настройке проекта мониторинга в Semaphore.

## 📋 Шаг 1: Создание проекта

1. Войдите в Semaphore: `http://localhost:3000`
   - Email: `admin@localhost` или `admin`
   - Пароль: `CHANGE_THIS_PASSWORD` (установите свой пароль в docker-compose.yml)

2. Нажмите **"New Project"** (или кнопку "+" в левом меню)

3. Заполните форму:
   - **Name**: `Server Monitoring`
   - **Description**: `Мониторинг сервера через Ansible`
   - Нажмите **"Create"**

---

## 📋 Шаг 2: Настройка инвентаря

1. В созданном проекте перейдите в раздел **"Inventory"**

2. Нажмите **"New Inventory"**

3. Заполните форму:
   - **Name**: `servers`
   - **Type**: `Static`
   - **Inventory**: вставьте содержимое вашего `inventory.ini`:

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

4. Нажмите **"Save"**

---

## 📋 Шаг 3: Настройка ключей SSH

SSH ключи уже скопированы в контейнер, но нужно проверить:

```bash
# Проверка что ключи на месте
docker exec ansible-semaphore ls -la /ansible/.ssh/

# Если ключей нет, скопируйте:
docker cp ~/.ssh/id_rsa ansible-semaphore:/ansible/.ssh/
docker cp ~/.ssh/id_rsa.pub ansible-semaphore:/ansible/.ssh/
docker exec ansible-semaphore chmod 600 /ansible/.ssh/id_rsa
docker exec ansible-semaphore chmod 644 /ansible/.ssh/id_rsa.pub
```

---

## 📋 Шаг 4: Создание шаблона задачи

1. В проекте перейдите в раздел **"Templates"**

2. Нажмите **"New Template"**

3. Заполните форму:
   - **Name**: `Server Monitoring`
   - **Inventory**: выберите `servers` (созданный ранее)
   - **Playbook**: `/ansible/monitoring.yml`
   - **Description**: `Мониторинг CPU, RAM, Disk и статуса сайта`
   - **Arguments**: оставьте пустым (или добавьте `-v` для подробного вывода)

4. Нажмите **"Save"**

---

## 📋 Шаг 5: Запуск задачи

1. Перейдите в раздел **"Templates"**

2. Найдите созданный шаблон **"Server Monitoring"**

3. Нажмите кнопку **"Run"** (или иконку ▶️)

4. Следите за выполнением в реальном времени:
   - Видно прогресс выполнения задач
   - Логи выполнения
   - Результаты

---

## 📋 Шаг 6: Просмотр результатов

1. Перейдите в раздел **"Tasks"**

2. Выберите выполненную задачу

3. Просмотрите:
   - **Output** - вывод выполнения
   - **Logs** - логи задач
   - **Status** - статус выполнения

---

## ⏰ Шаг 7: Планирование задач (опционально)

1. Перейдите в раздел **"Templates"**

2. Выберите шаблон **"Server Monitoring"**

3. Нажмите **"Schedule"** (или иконку календаря)

4. Настройте расписание:
   - **Schedule**: выберите частоту (например, каждые 5 минут)
   - **Cron Expression**: `*/5 * * * *` (каждые 5 минут)
   - Нажмите **"Save"**

---

## 🔧 Дополнительные настройки

### Настройка переменных окружения

Если нужно добавить переменные:

1. Перейдите в **"Templates"** → выберите шаблон
2. Раздел **"Environment Variables"**
3. Добавьте переменные (если нужны)

### Настройка уведомлений

1. Перейдите в **"Settings"** → **"Notifications"**
2. Настройте уведомления (Email, Telegram и т.д.)

---

## ✅ Проверка работы

После настройки:

1. Запустите задачу вручную через **"Run"**
2. Проверьте результаты в разделе **"Tasks"**
3. Проверьте что JSON файлы созданы на сервере:

```bash
ssh your_username@your-server-ip "cat /srv/projects/monitoring/dashboard/data.json"
```

---

## 🎯 Готово!

Теперь вы можете:
- ✅ Запускать мониторинг через веб-интерфейс
- ✅ Планировать автоматические задачи
- ✅ Просматривать историю выполнения
- ✅ Управлять несколькими серверами

---

## ⚠️ Решение проблем

### Проблема: Задача не запускается

- Проверьте что инвентарь настроен правильно
- Проверьте путь к playbook: `/ansible/monitoring.yml`
- Проверьте логи в разделе "Tasks"

### Проблема: Ошибка подключения к серверу

- Проверьте SSH ключи в контейнере
- Проверьте что сервер доступен
- Проверьте настройки инвентаря

### Проблема: Playbook не находит файлы

- Убедитесь что путь правильный: `/ansible/monitoring.yml`
- Проверьте что файлы смонтированы в контейнер

