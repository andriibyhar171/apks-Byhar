# Звіт
# з лабораторної роботи №1

## Проєктування AI-агента для автоматизації розробки та CI/CD

**Виконав:** Бигар Андрій Богданович  
**Група:** КІ-407  
**Варіант:** 1  
**Мова:** C++17  
**Система складання:** CMake  
**Тестування:** GoogleTest / CTest

## 1. Мета роботи

Набути навичок проєктування спеціалізованого AI-агента, який автоматизує
генерацію вихідного коду, складання, тестування і перевірку
кросплатформного C++-проєкту.

## 2. Постановка задачі

Потрібно створити мінімальний застосунок `Hello, World!`, тест
`BasicAddition`, конфігурацію CMake, локальні сценарії перевірки та GitHub
Actions для Windows, Linux і macOS. Додатково потрібно описати agent manifest,
skills, commands та orchestrator, який зупиняється при помилці.

## 3. Архітектура агента

```text
build-engineer.agent.md
        |
        v
init (orchestrator)
  |
  +--> git-init
  +--> create-project --> project-scaffold
  +--> create-build   --> build-and-test
  +--> create-actions --> github-actions
  +--> check
```

Manifest задає роль, правила безпеки, обмеження роботи з файлами та критерії
завершення. Skills описують повторювані операції, commands запускають їх явно,
а `init` координує виконання в заданому порядку. Команда `check` не повинна
змінювати проєкт і повертає помилку, якщо будь-яка перевірка не пройшла.

## 4. Файли агента

- Manifest: `.github/agents/build-engineer.agent.md`.
- Skills:
  - `.github/skills/project-scaffold/SKILL.md`;
  - `.github/skills/build-and-test/SKILL.md`;
  - `.github/skills/github-actions/SKILL.md`.
- Commands:
  - `.github/prompts/git-init.prompt.md`;
  - `.github/prompts/create-project.prompt.md`;
  - `.github/prompts/create-build.prompt.md`;
  - `.github/prompts/create-actions.prompt.md`;
  - `.github/prompts/check.prompt.md`;
  - `.github/prompts/init.prompt.md`.

## 5. Вихідний проєкт

Основні файли:

- `src/hello.h` і `src/hello.cpp` містять `hello::message()`;
- `src/main.cpp` виводить `Hello, World!`;
- `CMakeLists.txt` підключає GoogleTest через FetchContent, створює
  `hello`, `hello_tests` і CTest-тести;
- `tests/hello_test.cpp` містить `BasicAddition` і перевірку повідомлення;
- `ci.sh` і `ci.bat` виконують configure, build та CTest;
- `.github/workflows/ci.yml` використовує одну matrix job для трьох ОС.

## 6. Результати локальної перевірки

Команда Windows:

```bat
ci.bat
```

Результат:

```text
HelloTest.BasicAddition .......... Passed
HelloTest.MessageIsCorrect ....... Passed
100% tests passed out of 2
```

Виконуваний файл `build/Release/hello.exe` запускається і виводить:

```text
Hello, World!
```

Каталог `build/` і його вміст ігноруються Git.

## 7. GitHub Actions

Workflow запускається для `push` і `pull_request` у гілки `master` та `develop`.
Matrix містить `ubuntu-latest`, `windows-latest` і `macos-latest`. На кожній
системі запускається відповідний локальний сценарій CI.

**Посилання на репозиторій:** _додати після публікації_  
**Посилання на успішний запуск Actions:** _додати після першого запуску_  
**Посилання на Pull Request `lab1/finish`:** _додати після створення_

## 8. Git-процес

Робочі зміни підготовлено для гілки `feature/lab1`. Перед здаванням їх потрібно
перенести через Pull Request у `develop`, а після перевірки — у `master`.
Каталоги складання не додаються до Git.

## 9. Висновок

Створено AI-агента, який автоматизує підготовку C++17 Hello World-проєкту,
CMake-складання, GoogleTest/CTest і GitHub Actions. Ідемпотентні commands можна
запускати повторно, а `check` не приховує помилки. Обмеження агента описують
заборону роботи із секретами, небезпечними Git-операціями та неперевіреними
результатами.
