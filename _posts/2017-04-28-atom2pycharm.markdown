---
title: Как я перекатываюсь с atom на pycharm
---

# Сделано

1. Включил опцию Ensure line feed at file end on Save. 
2. Включил опцию Surround selection on typing quotes or brace.
3. Отображение warning'ов как в atom-linter: code -> inspection.
4. Включил опцию: Strip trailing spaces on Save - Modified lines
5. Настройки BashSupport:
  - отключены проверки:
    - evaluate expansion
    - convert simple brackets to double brackets
  - включены проверки:
    - convert backquote to subshell command
6. Code Style -> Other File Types:
  - включен Use tab character
  - tab size 8
  - indent 8

# Страдания

1. Не разобрался как всё же прилепить pylint чтобы отображался в code -> inspections вдобавок к имеющимся проверкам. Месяц назад видел на форуме JetBrains что идите нафиг, наш линтер и так хороший.
2. Ещё не копал как отображать юнит-тесты.
3. Не нашёл как врубить autopep8
