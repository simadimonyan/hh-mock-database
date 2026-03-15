-- 4 --

SELECT
    DATE_TRUNC('month', published_at) AS month,
    COUNT(*) AS vacancies_count
FROM vacancies
GROUP BY month
ORDER BY vacancies_count DESC
LIMIT 1;

SELECT
    DATE_TRUNC('month', created_at) AS month,
    COUNT(*) AS resumes_count
FROM resumes
GROUP BY month
ORDER BY resumes_count DESC
LIMIT 1;