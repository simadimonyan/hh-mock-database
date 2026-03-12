# Mock HH Database

Учебный проект, моделирующий упрощённую базу данных сервиса поиска работы, аналогичного hh.ru.  
Проект демонстрирует проектирование схемы базы данных, генерацию тестовых данных и выполнение аналитических SQL‑запросов.

В проекте используется СУБД PostgreSQL, развёрнутая через Docker Compose.  
Также используется pgAdmin для удобной работы с базой данных через веб‑интерфейс.

---

# Архитектура базы данных

База данных моделирует основные сущности рынка труда:

- вакансии
- резюме
- отклики
- специализации

Связи между сущностями:

- одна специализация может быть у множества вакансий и резюме
- одно резюме может откликаться на множество вакансий
- одна вакансия может получать множество откликов

Таким образом таблица `responses` реализует связь many‑to‑many между резюме и вакансиями.

## Таблицы

### specializations

Справочник специализаций.

Поля:

- `id` — первичный ключ
- `name` — название специализации

---

### resumes

Таблица резюме кандидатов.

Поля:

- `id` — первичный ключ
- `title` — название резюме
- `candidate_name` — имя кандидата
- `area_id` — регион
- `specialization_id` — специализация
- `salary_expectation_from` — минимальная ожидаемая зарплата
- `salary_expectation_to` — максимальная ожидаемая зарплата
- `created_at` — дата создания резюме

---

### vacancies

Таблица вакансий.

Поля:

- `id` — первичный ключ
- `title` — название вакансии
- `company_name` — название компании
- `area_id` — регион
- `specialization_id` — специализация
- `compensation_from` — минимальная зарплата
- `compensation_to` — максимальная зарплата
- `published_at` — дата публикации

---

### responses

Таблица откликов.

Поля:

- `id` — первичный ключ
- `vacancy_id` — вакансия
- `resume_id` — резюме
- `responded_at` — дата отклика

Эта таблица реализует связь many‑to‑many между вакансиями и резюме.

---

# Генерация тестовых данных

Для генерации данных используется SQL‑функция PostgreSQL:

```
generate_series()
```

Она позволяет быстро создать большое количество строк.

В проекте генерируется:

- 30 специализаций
- 100 000 резюме
- 10 000 вакансий
- ~300 000 откликов

При генерации соблюдаются логические ограничения:

- `salary_to >= salary_from`
- отклик не может быть раньше публикации вакансии
- резюме откликается только на вакансию своей специализации

---

# SQL запросы из задания

## 1. Средние зарплаты по регионам

```
SELECT
    area_id,
    AVG(compensation_from) AS avg_compensation_from,
    AVG(compensation_to) AS avg_compensation_to,
    AVG((compensation_from + compensation_to) / 2.0) AS avg_middle_compensation
FROM vacancies
GROUP BY area_id
ORDER BY area_id;
```

Запрос рассчитывает:

- среднюю минимальную зарплату
- среднюю максимальную зарплату
- среднюю зарплату между `from` и `to`

по каждому региону (`area_id`).

---

## 2. Месяц с наибольшим количеством вакансий

```
SELECT
    DATE_TRUNC('month', published_at) AS month,
    COUNT(*) AS vacancies_count
FROM vacancies
GROUP BY month
ORDER BY vacancies_count DESC
LIMIT 1;
```

Запрос группирует вакансии по месяцу публикации и находит месяц с максимальным количеством вакансий.

---

## 3. Месяц с наибольшим количеством резюме

```
SELECT
    DATE_TRUNC('month', created_at) AS month,
    COUNT(*) AS resumes_count
FROM resumes
GROUP BY month
ORDER BY resumes_count DESC
LIMIT 1;
```

Аналогичный запрос для резюме.

---

## 4. Вакансии с более чем 5 откликами за первую неделю

```
SELECT
    v.id,
    v.title
FROM vacancies v
JOIN responses r ON r.vacancy_id = v.id
WHERE r.responded_at <= v.published_at + INTERVAL '7 days'
GROUP BY v.id, v.title
HAVING COUNT(r.id) > 5;
```

Запрос находит вакансии, которые получили более 5 откликов в течение первой недели после публикации.

---

# Индексы и их обоснование

Для ускорения выполнения аналитических запросов были добавлены индексы.

## idx_vacancies_area_id

```
CREATE INDEX idx_vacancies_area_id
ON vacancies(area_id);
```

Используется для ускорения группировки:

```
GROUP BY area_id
```

Индекс позволяет быстрее агрегировать данные по регионам.

---

## idx_vacancies_published_at

```
CREATE INDEX idx_vacancies_published_at
ON vacancies(published_at);
```

Используется в аналитике по времени публикации вакансий.

Позволяет быстрее выполнять запросы, которые группируют вакансии по месяцам.

---

## idx_resumes_created_at

```
CREATE INDEX idx_resumes_created_at
ON resumes(created_at);
```

Используется для анализа динамики создания резюме по времени.

---

## idx_responses_vacancy_id

```
CREATE INDEX idx_responses_vacancy_id
ON responses(vacancy_id);
```

Критически важный индекс для запроса:

```
JOIN responses r ON r.vacancy_id = v.id
```

Позволяет быстро находить все отклики для конкретной вакансии.

---

## idx_responses_responded_at

```
CREATE INDEX idx_responses_responded_at
ON responses(responded_at);
```

Используется в фильтрации:

```
responded_at <= published_at + interval '7 days'
```

Позволяет быстрее находить отклики за определённый период времени.

---

# Запуск проекта

Проект запускается через Docker Compose.

Запуск контейнеров:

```
docker compose up
```

После запуска будут доступны:

PostgreSQL  
порт: **5432**

pgAdmin  
http://localhost:15432

Данные для входа в pgAdmin:

```
email: admin@pgadmin.com
password: admin
```
