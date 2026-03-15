-- 2 --

INSERT INTO specializations (id, name)
SELECT i, 'Specialization ' || i
FROM generate_series(1, 30) AS s(i);

INSERT INTO resumes (
    title,
    candidate_name,
    area_id,
    specialization_id,
    salary_expectation_from,
    salary_expectation_to,
    created_at
)
SELECT
    'Resume ' || i,
    'Candidate ' || i,
    (random()*20)::int + 1,
    spec_id,
    salary_from,
    salary_from + (random()*50000)::int,
    NOW() - random() * interval '365 days'
FROM (
    SELECT
        i,
        (random()*29)::int + 1 AS spec_id,
        (random()*80000)::int + 40000 AS salary_from
    FROM generate_series(1,100000) i
) t;

INSERT INTO Vacancies (
    title,
    company_name,
    area_id,
    specialization_id,
    compensation_from,
    compensation_to,
    published_at
)
SELECT
    'Vacancy ' || i,
    'Company ' || ((random()*500)::int + 1),
    (random()*20)::int + 1,
    spec_id,
    salary_from,
    salary_from + (random()*70000)::int,
    NOW() - random() * interval '365 days'
FROM (
    SELECT
        i,
        (random()*29)::int + 1 AS spec_id,
        (random()*90000)::int + 50000 AS salary_from
    FROM generate_series(1,10000) i
) t;


INSERT INTO responses (
    vacancy_id,
    resume_id,
    responded_at
)
SELECT
    v.id,
    r.id,
    v.published_at + (random() * interval '120 days' - interval '10 days')
FROM vacancies v
JOIN LATERAL (
    SELECT id
    FROM resumes
    WHERE specialization_id = v.specialization_id
    ORDER BY random()
    LIMIT 30
) r ON TRUE
LIMIT 300000;