/*
Answer: What are the most optimal skills to learn (aka it's in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified
salaries - Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
offering strategic insights for career development in data analysis
*/

WITH highest_demand_skills AS (
    SELECT 
        skills_dim.skills,
        skills_dim.skill_id,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        job_work_from_home = True AND
        salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
), highest_paying_skills AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = True
    GROUP BY skills_job_dim.skill_id
)

SELECT
    highest_demand_skills.skill_id,
    highest_demand_skills.skills,
    highest_demand_skills.demand_count,
    highest_paying_skills.avg_salary
FROM highest_demand_skills
INNER JOIN highest_paying_skills ON highest_demand_skills.skill_id = highest_paying_skills.skill_id
WHERE highest_demand_skills.demand_count > 10
ORDER BY 
    highest_paying_skills.avg_salary DESC,
    highest_demand_skills.demand_count DESC
LIMIT 25