-- 1 --

CREATE TABLE Specializations (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE Resumes (
    id BIGSERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    candidate_name TEXT,
    area_id INTEGER NOT NULL,
    specialization_id INTEGER REFERENCES specializations(id),
    salary_expectation_from INTEGER,
    salary_expectation_to INTEGER,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE Vacancies (
    id BIGSERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    company_name TEXT,
    area_id INTEGER NOT NULL,
    specialization_id INTEGER REFERENCES specializations(id),
    compensation_from INTEGER,
    compensation_to INTEGER,
    published_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE Responses (
    id BIGSERIAL PRIMARY KEY,
    vacancy_id BIGINT NOT NULL REFERENCES Vacancies(id) ON DELETE CASCADE,
    resume_id BIGINT NOT NULL REFERENCES Resumes(id) ON DELETE CASCADE,
    responded_at TIMESTAMP NOT NULL DEFAULT now()
);
