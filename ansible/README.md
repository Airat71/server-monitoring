# Monitoring Dashboard Automation (Freelance Ready)

Эта роль Ansible превращает сырой VPS в наглядный monitoring dashboard: собирает нагрузку, проверяет доступность ключевого сайта и выгружает JSON артефакты, готовые к интеграции в UI. Репозиторий оформлен так, чтобы быстро показать производство-готовый результат потенциальному заказчику.

## 🎯 Что получает заказчик

- Автоматизированную установку дашборда мониторинга за один `ansible-playbook`
- JSON-метрики и лог, которые легко забрать фронтендом или BI-инструментом
- Инфраструктурную документацию: схема потока данных и примеры выгрузки
- CI-пайплайн с `ansible-lint` и `yamllint`, подтверждающий качество кода
- Возможность расширять роль за счёт переменных (`monitoring_*`) без рефакторинга

## 📦 Структура

```
ansible/
├── README.md
├── ansible.cfg              # Общие настройки (roles_path, inventory)
├── .yamllint                # Настройки стиля YAML
├── docs/                      # Артефакты и вспомогательные материалы
│   ├── monitoring-data-sample.json
│   ├── monitoring-website-sample.json
│   └── monitoring-flow.md
├── inventories/               # Примеры inventory
│   ├── example.ini
│   └── servers.ini
├── playbooks/
│   └── monitoring.yml         # Продакшн-playbook (serial, env, gather_facts)
└── roles/
    └── monitoring/
        ├── defaults/main.yml  # Переменные и список пакетов
        ├── tasks/main.yml     # Сбор метрик + рендер JSON/логов
        └── templates/*.j2
```

## 🧩 Архитектура

- **Контроллер**: запускает playbook, тянет пакеты и прогоняет lint-пайплайн.
- **Роль `monitoring`**: собирает CPU/RAM/Disk через стандартные утилиты Linux, проверяет доступность сайта с помощью `curl`, нормализует значения и оценивает статусы.
- **Артефакты**: шаблоны Jinja2 записывают данные в `dashboard/data.json` и `dashboard/website_status.json`, а `lineinfile` ведёт журнал `logs/monitoring.log`.
- **Визуализация**: фронтенд или BI инструмент подключается к JSON напрямую (см. примеры в `docs/`).

Диаграмма потока: `docs/monitoring-flow.md` (Mermaid-диаграмма, которую можно вставить в презентацию или Notion).

```
Управляющий хост ── ansible-playbook ──► Целевой сервер
                                         ├─ scripts (bash)
                                         ├─ dashboard/data.json
                                         └─ logs/monitoring.log
```

## 🚀 Запуск

1. Установите Python 3.11+ и Ansible ≥ 2.15 (`pip install ansible`).
2. Скопируйте inventory и пропишите доступы к серверу:
   ```bash
   cp inventories/example.ini inventories/prod.ini
   vim inventories/prod.ini
   ```
3. Проверьте подключение и права `become` (playbook уже включает `become: true`).
4. Выполните dry-run, чтобы убедиться в идемпотентности:
   ```bash
   ansible-playbook --check -i inventories/prod.ini playbooks/monitoring.yml
   ```
5. Запустите основной прогон:
   ```bash
   ansible-playbook -i inventories/prod.ini playbooks/monitoring.yml
   ```

Playbook исполняется `serial: 1`, поэтому безопасен для продакшн-серверов с минимальным простоем.

> ℹ️  В корне репозитория лежит `monitoring.yml`, который просто импортирует `ansible/playbooks/monitoring.yml`. Этим файлом удобно пользоваться в CI/CD или Semaphore, где путь к проекту уже жёстко задан.

## ⚙️ Переменные

| Переменная | Назначение | Значение по умолчанию |
| --- | --- | --- |
| `monitoring_dir` | Корневая директория проекта | `/srv/projects/monitoring` |
| `monitoring_dashboard_dir` | Путь для JSON-дашборда | `{{ monitoring_dir }}/dashboard` |
| `monitoring_logs_dir` | Папка для `monitoring.log` | `{{ monitoring_dir }}/logs` |
| `monitoring_owner` / `monitoring_group` | Владелец и группа файлов | `airat` / `labusers` |
| `monitoring_packages_common` | Пакеты для любой ОС | `['curl', 'coreutils']` |
| `monitoring_packages_family_map` | Доп. пакеты по семейству ОС | Debian → `['procps']`, RedHat → `['procps-ng']` |
| `monitoring_website_url` | Точка, которую пингуем | `https://example.com` |
| `monitoring_*_warning` / `monitoring_*_critical` | Пороги статусов CPU/RAM/Disk | 70/90, 80/90, 80/90 |

Переменные можно переопределять в `group_vars`, `host_vars` или прямо в inventory. Пакетные списки объединяются и очищаются от дубликатов перед установкой.

## 🧾 Артефакты для портфолио

- `docs/monitoring-data-sample.json` — пример payload-а для фронтенда.
- `docs/monitoring-website-sample.json` — ответ health-check для страницы.
- `docs/monitoring-flow.md` — Mermaid диаграмма потока данных (готова к вставке в презентацию).

Эти файлы можно показать заказчику как proof-of-delivery без доступа к продакшну.

## ✅ Проверка

```bash
# локальный запуск lintов (как в CI)
cd ansible
pip install --user ansible ansible-lint yamllint
yamllint .
ansible-lint playbooks/monitoring.yml

# проверка конфигурации без применения
ansible-playbook --check -i inventories/prod.ini playbooks/monitoring.yml
```

## 🤖 CI

- Workflow: `.github/workflows/ansible-ci.yml`
- Запускается на `push`/`PR` с изменениями в каталоге `ansible/`
- Шаги: установка Python 3.11, `yamllint .`, `ansible-lint playbooks/monitoring.yml`
- Рабочая директория в джобе — `ansible/`, поэтому конфигурация `yamllint` подхватывается автоматически

Успешный прогон CI — готовый скриншот для отклика на проект.

## 🗂️ Дополнительно

- Настройка Ansible Semaphore: `docs/SEMAPHORE_SETUP.md` и `docs/SEMAPHORE_CONFIG.md`
- Сравнение интерфейсов и dev-окружение: `docs/GUI_COMPARISON.md`, `docs/VSCODE_SETUP.md`
- Легаси-описание проекта: `docs/LEGACY_README.md`
- Хендовер заметки: `docs/NEXT_CHAT_HANDOVER.md`

## 📌 Следующие шаги

- Добавить экспортер в Prometheus или Pushgateway для метрик на стороне заказчика
- Собрать systemd timer / cron роль для регулярного запуска playbook без внешних инструментов
- Расширить `monitoring_packages_family_map` поддержкой Alpine/Arch при необходимости
- Подготовить скриншоты фронтенда (HTML из корня репозитория) и привязать к JSON

