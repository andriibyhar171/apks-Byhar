# Command: create-actions

Використай skill `github-actions`. Створи `ci.sh`, `ci.bat` та
`.github/workflows/ci.yml`. Workflow має запускатися на push і pull_request до
`master`/`develop`, використовувати одну matrix-job для Ubuntu, Windows і macOS
та запускати тільки локальні CI-скрипти. Перевір YAML і наявність усіх runner-ів.

