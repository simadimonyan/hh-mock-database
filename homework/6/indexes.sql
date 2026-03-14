-- 6 --

CREATE INDEX idx_vacancies_area_id
ON vacancies(area_id);

CREATE INDEX idx_vacancies_published_at
ON vacancies(published_at);

CREATE INDEX idx_resumes_created_at
ON resumes(created_at);

CREATE INDEX idx_responses_vacancy_id
ON responses(vacancy_id);

CREATE INDEX idx_responses_responded_at
ON responses(responded_at);

CREATE INDEX idx_responses_resume_id
ON responses(resume_id);