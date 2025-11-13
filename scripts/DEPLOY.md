# Инструкция по загрузке дашборда на сервер

## Файлы созданы локально:

- `index.html` - веб-дашборд
- `check_website_json.sh` - скрипт для проверки сайта

---

## Загрузка на сервер:

### Вариант 1: Через scp (рекомендую)

```bash
# С вашего компьютера
cd /path/to/monitoring-dashboard

# Загрузить файлы на сервер (замените user@server_ip на ваши данные)
scp index.html user@your-server-ip:/srv/projects/monitoring/dashboard/
scp check_website_json.sh user@your-server-ip:/srv/projects/monitoring/scripts/

# На сервере дать права на выполнение
ssh user@your-server-ip
chmod +x /srv/projects/monitoring/scripts/check_website_json.sh
```

### Вариант 2: Через nano на сервере

```bash
# На сервере
nano /srv/projects/monitoring/dashboard/index.html
# Вставьте содержимое файла index.html
# Сохраните: Ctrl+O, Enter, Ctrl+X
```

---

## Настройка nginx для дашборда:

После загрузки файлов нужно настроить nginx чтобы дашборд был доступен.

```bash
# На сервере создайте конфиг
sudo nano /etc/nginx/sites-available/monitoring
```

Вставьте:

```nginx
server {
    listen 8080;
    server_name localhost;

    root /srv/projects/monitoring/dashboard;
    index index.html;

    location /monitoring/ {
        alias /srv/projects/monitoring/dashboard/;
        try_files $uri $uri/ =404;
    }

    location /monitoring/data.json {
        alias /srv/projects/monitoring/dashboard/data.json;
    }

    location /monitoring/website_status.json {
        alias /srv/projects/monitoring/dashboard/website_status.json;
    }
}
```

Активируйте:

```bash
sudo ln -s /etc/nginx/sites-available/monitoring /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

---

## Настройка автоматического обновления:

Добавьте в crontab:

```bash
crontab -e
```

Добавьте строки:

```
# Обновление метрик каждые 5 минут
*/5 * * * * /srv/projects/monitoring/scripts/check_resources.sh > /dev/null 2>&1

# Проверка сайта каждые 5 минут
*/5 * * * * /srv/projects/monitoring/scripts/check_website_json.sh > /dev/null 2>&1
```

---

## Доступ к дашборду:

После настройки nginx дашборд будет доступен по адресу:

```
http://your-server-ip:8080/monitoring/
```

Или если настроите домен:

```
http://monitoring.yourdomain.com
```

---

## Проверка:

1. Загрузите файлы на сервер
2. Настройте nginx
3. Запустите скрипты вручную для проверки
4. Откройте дашборд в браузере

