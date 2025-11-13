# Настройка VS Code для работы с Ansible

Расширения для удобной работы с Ansible playbook в VS Code.

## 📋 Описание

VS Code расширения для Ansible предоставляют:
- Подсветку синтаксиса YAML
- Автодополнение для Ansible модулей
- Валидацию playbook
- Навигацию по файлам
- Интеграцию с Ansible

## 🚀 Установка расширений

### Способ 1: Через интерфейс VS Code

1. Откройте VS Code
2. Нажмите `Cmd+Shift+X` (или `Ctrl+Shift+X` на Windows/Linux)
3. Найдите и установите расширения:

#### Основные расширения:

1. **Ansible** (by Red Hat)
   - ID: `redhat.ansible`
   - Подсветка синтаксиса
   - Автодополнение
   - Валидация

2. **Ansible Vault** (by Red Hat)
   - ID: `redhat.vscode-ansible-vault`
   - Работа с Ansible Vault

3. **YAML** (by Red Hat)
   - ID: `redhat.vscode-yaml`
   - Поддержка YAML

### Способ 2: Через командную строку

```bash
# Установка через командную строку
code --install-extension redhat.ansible
code --install-extension redhat.vscode-ansible-vault
code --install-extension redhat.vscode-yaml
```

## ⚙️ Настройка

### 1. Настройка путей к Ansible

Откройте настройки VS Code (`Cmd+,`):

```json
{
  "ansible.python.interpreterPath": "/opt/homebrew/bin/python3",
  "ansible.ansible.path": "/opt/homebrew/bin/ansible",
  "ansible.ansiblePlaybook.path": "/opt/homebrew/bin/ansible-playbook",
  "ansible.ansibleLint.enabled": true,
  "ansible.ansibleLint.path": "/opt/homebrew/bin/ansible-lint"
}
```

### 2. Настройка для проекта

Создайте файл `.vscode/settings.json` в директории проекта:

```json
{
  "ansible.python.interpreterPath": "/opt/homebrew/bin/python3",
  "ansible.ansible.path": "/opt/homebrew/bin/ansible",
  "ansible.ansiblePlaybook.path": "/opt/homebrew/bin/ansible-playbook",
  "files.associations": {
    "*.yml": "ansible",
    "*.yaml": "ansible"
  }
}
```

## 🎯 Использование

### Подсветка синтаксиса

- Автоматически работает для файлов `.yml` и `.yaml`
- Подсвечивает Ansible модули, переменные, задачи

### Автодополнение

- Начните вводить название модуля (например, `copy:`)
- Нажмите `Ctrl+Space` для автодополнения
- Показывает параметры модулей

### Валидация

- Ошибки подчёркиваются красным
- Предупреждения - жёлтым
- Наведите курсор для просмотра деталей

### Навигация

- `Cmd+Click` (или `Ctrl+Click`) на переменной для перехода к определению
- `F12` - переход к определению
- `Shift+F12` - найти все использования

## 🔧 Дополнительные возможности

### Запуск playbook из VS Code

1. Установите расширение **Task Runner**
2. Создайте файл `.vscode/tasks.json`:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Run Ansible Playbook",
      "type": "shell",
      "command": "ansible-playbook -i inventory.ini monitoring.yml",
      "options": {
        "cwd": "${workspaceFolder}"
      },
      "problemMatcher": []
    }
  ]
}
```

3. Запустите через `Cmd+Shift+P` → "Tasks: Run Task" → "Run Ansible Playbook"

### Интеграция с терминалом

1. Откройте терминал в VS Code (`Ctrl+``)
2. Запустите команды Ansible напрямую

### Сниппеты

Расширение Ansible включает готовые сниппеты:

- `ansible-playbook` - шаблон playbook
- `ansible-task` - шаблон задачи
- `ansible-handler` - шаблон обработчика

## 📝 Примеры использования

### Создание нового playbook

1. Создайте файл `new-playbook.yml`
2. Начните вводить `ansible-playbook`
3. Выберите сниппет из автодополнения
4. Заполните шаблон

### Редактирование существующего playbook

1. Откройте `monitoring.yml`
2. Используйте автодополнение для модулей
3. Проверьте валидацию (ошибки подчёркнуты)
4. Используйте навигацию для перехода к переменным

## 🎨 Полезные расширения

### Дополнительно можно установить:

1. **GitLens** - работа с Git
2. **Docker** - работа с Docker
3. **Remote - SSH** - подключение к серверам
4. **YAML** - улучшенная поддержка YAML

## ⚠️ Решение проблем

### Проблема: Автодополнение не работает

```bash
# Проверьте что Ansible установлен
which ansible

# Проверьте настройки VS Code
code --list-extensions | grep ansible
```

### Проблема: Валидация не работает

1. Проверьте настройки путей к Ansible
2. Перезапустите VS Code
3. Проверьте что файл имеет расширение `.yml` или `.yaml`

### Проблема: Подсветка синтаксиса не работает

1. Убедитесь что расширение установлено
2. Проверьте ассоциации файлов в настройках
3. Перезапустите VS Code

## 📚 Дополнительная информация

- [Документация расширения Ansible](https://marketplace.visualstudio.com/items?itemName=redhat.ansible)
- [VS Code документация](https://code.visualstudio.com/docs)

## ✅ Проверка установки

После установки расширений:

1. Откройте `monitoring.yml`
2. Проверьте подсветку синтаксиса
3. Попробуйте автодополнение (начните вводить `copy:`)
4. Проверьте валидацию (ошибки должны подчёркиваться)

## 🎯 Рекомендации

- Используйте VS Code для разработки playbook
- Используйте Semaphore для запуска и управления задачами
- Комбинируйте оба подхода для максимальной эффективности

