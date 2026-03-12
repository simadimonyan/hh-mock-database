-- 3 --

SELECT
    area_id,
    AVG(compensation_from) AS avg_compensation_from,
    AVG(compensation_to) AS avg_compensation_to,
    AVG((compensation_from + compensation_to) / 2.0) AS avg_middle_compensation
FROM vacancies
GROUP BY area_id
ORDER BY area_id;