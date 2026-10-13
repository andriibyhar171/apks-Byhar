---
name: github-actions
description: Кросплатформний GitHub Actions workflow
---

# GitHub Actions

**Вхід:** готові CMake-проєкт і `ci.sh`/`ci.bat`.  
**Результат:** `.github/workflows/ci.yml` з однією job і matrix
`ubuntu-latest`, `windows-latest`, `macos-latest`.  
**Дії:** checkout, запуск відповідного локального скрипта, зрозумілий job
summary; не дублювати команди складання у YAML.  
**Перевірка:** YAML має triggers для `push` і `pull_request` на `master` та
`develop`, а кожен runner виконує configure/build/test.  
**Помилка:** повідомити відсутній runner, скрипт або некоректний YAML і
зупинити створення workflow.

