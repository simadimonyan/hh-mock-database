-- 5 --

SELECT
    v.id,
    v.title
FROM vacancies v
JOIN responses r ON r.vacancy_id = v.id
WHERE r.responded_at <= v.published_at + INTERVAL '7 days'
GROUP BY v.id, v.title
HAVING COUNT(r.id) > 5
ORDER BY v.id;