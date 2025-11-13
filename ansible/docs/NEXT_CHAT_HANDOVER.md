# Handover Notes — Monitoring Project (Ansible + Semaphore)

## Текущее состояние
- Плейбук `monitoring.yml` обновлён: переменная `website_url` указывает на `https://example.com`.
- Скрипт `check_website.sh` на сервере (`/srv/projects/monitoring/scripts/check_website.sh`) и в репозитории проверяет тот же URL и пишет логи в `/srv/projects/monitoring/logs/website_check.log`.
- Semaphore развёрнут через `docker-compose` в `ansible/semaphore`. Контейнеры `ansible-semaphore` и `semaphore-mysql` запущены (`docker-compose ps`).
- Последний запуск плейбука (локально и через Semaphore) завершился успешно, метрики сохранены в `/srv/projects/monitoring/dashboard/data.json` и `website_status.json`.

## Что осталось сделать
1. **Настройка:** обновить переменную `monitoring_website_url` в `roles/monitoring/defaults/main.yml` на ваш URL.
2. **Гит:** при необходимости закоммитить/запушить изменения (обновлённый `monitoring.yml`, `check_website.sh`).
3. **Расписание:** при желании настроить запуск в Semaphore (`Templates → Server Monitoring → Schedule`).

## Полезные команды
```bash
# Запуск плейбука
cd /path/to/server-monitoring
ansible-playbook -i ansible/inventories/servers.ini ansible/monitoring.yml

# Запуск через docker-compose (Semaphore)
cd /path/to/server-monitoring/ansible/semaphore
docker-compose up -d
docker-compose ps

# Проверка сайта напрямую
curl -I https://example.com

# Проверка скрипта на сервере
ssh your_username@your-server-ip "/srv/projects/monitoring/scripts/check_website.sh"
```

## Документация
- `README.md` — общий обзор
- `SEMAPHORE_SETUP.md` — установка и настройка Semaphore
- `SEMAPHORE_CONFIG.md` — пошаговая конфигурация внутри UI
- `VSCODE_SETUP.md` — настройка расширений
- `GUI_COMPARISON.md` — сравнение интерфейсов

