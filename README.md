# Hello Agent — лабораторна робота №1

**ПІП:** Бигар Андрій Богданович  
**Група:** КІ-407  
**Варіант:** 1  
**Мова:** C++17  
**Складання:** CMake  
**Тестування:** GoogleTest і CTest

## Мета

Проєкт демонструє спеціалізованого AI-агента, який створює, збирає та перевіряє
мінімальний кросплатформний застосунок `Hello, World!`.

## Структура

- `.github/agents/build-engineer.agent.md` — manifest агента;
- `.github/skills/` — skills агента;
- `.github/prompts/` — команди агента, включно з оркестратором `init`;
- `src/` — вихідний код;
- `tests/` — тести GoogleTest;
- `ci.sh`, `ci.bat` — локальні кросплатформні сценарії CI;
- `.github/workflows/ci.yml` — GitHub Actions;
- `docs/` — архітектура та інструкція користувача.

## Локальний запуск

Потрібні CMake 3.20+, компілятор C++17 і доступ до GitHub під час першого
налаштування GoogleTest.

Linux/macOS:

```sh
./ci.sh
```

Windows:

```bat
ci.bat
```

Або окремо:

```sh
cmake -S . -B build
cmake --build build --config Release
ctest --test-dir build --build-config Release --output-on-failure
```

## Запуск агента

У VS Code з GitHub Copilot Chat відкрийте `.github/prompts/init.prompt.md` та
виконайте команду `init`. Після запуску збережіть результати локальної
перевірки та GitHub Actions у звіті.
