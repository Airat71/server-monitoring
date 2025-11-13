# Inventory Setup

1. Скопируйте пример:
   ```bash
   cp example.ini prod.ini
   ```
2. В `prod.ini` подставьте реальные IP / пользователей / ключи.
3. Никогда не коммитьте `prod.ini` или `servers.ini` — они добавлены в `.gitignore`.

Запуск:
```bash
ansible-playbook -i ansible/inventories/prod.ini playbooks/monitoring.yml
```
