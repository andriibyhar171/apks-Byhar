---
name: build-and-test
description: Створення CMake-конфігурації та GoogleTest перевірок
---

# Build and Test

**Вхід:** готовий C++17 `src/` і назва тесту.  
**Результат:** `CMakeLists.txt` із GoogleTest/CTest і `tests/hello_test.cpp` з
`BasicAddition`.  
**Дії:** налаштувати CMake, зібрати `hello` та тестовий executable, запустити
CTest із `--output-on-failure`.  
**Перевірка:** configure, build і всі тести завершуються з кодом 0.  
**Помилка:** показати команду та її stderr, зупинити подальші кроки, не
маскуючи невдалий тест.

