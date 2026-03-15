-- 3 --

SELECT
    area_id,
    AVG(COALESCE(compensation_from, compensation_to)) AS avg_compensation_from,
    AVG(COALESCE(compensation_to, compensation_from)) AS avg_compensation_to,
    AVG((COALESCE(compensation_from, compensation_to) + COALESCE(compensation_to, compensation_from)) / 2.0) AS avg_middle_compensation
FROM vacancies
GROUP BY area_id
ORDER BY area_id;