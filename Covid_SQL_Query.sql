--United States Data
SELECT location, population, date, total_cases_per_million, total_deaths_per_million, (total_deaths/total_cases)*100 as death_percentage
FROM covid_stats.dbo.covid_deaths
WHERE location like '%united states%'
ORDER BY 1,2

--New Zealand Data
SELECT location, population, date, total_cases_per_million, total_deaths_per_million, (total_deaths/total_cases)*100 as death_percentage
FROM covid_stats.dbo.covid_deaths
WHERE location like '%new zealand%'
ORDER BY 1,2

--India Data
SELECT location, population, date, total_cases_per_million, total_deaths_per_million, (total_deaths/total_cases)*100 as death_percentage
FROM covid_stats.dbo.covid_deaths
WHERE location like '%india%'
ORDER BY 1,2

--Countries with Highest Infection Rate relative to Population
SELECT location, population, MAX(total_cases) as totalcases, MAX((total_cases/population))*100 as percent_population_infected
FROM covid_stats.dbo.covid_deaths
GROUP BY location, population
ORDER BY 4 DESC

--Countries with Highest Death Rate realitve to Population
SELECT location, population, MAX(cast(total_deaths as int)) as totaldeaths, MAX((total_deaths/population))*100 as percent_population_dead
FROM covid_stats.dbo.covid_deaths
GROUP BY location, population
ORDER BY 4 DESC

--Data by Continent
SELECT DISTINCT continent, 100*MAX(cast(total_deaths as int))/MAX(total_cases) as death_percentage
FROM covid_stats.dbo.covid_deaths
WHERE continent is not null
GROUP BY continent
ORDER BY 2 DESC

--Global Data
SELECT MAX(total_cases) as total_cases, MAX(cast(total_deaths as int)) as total_deaths, 100*MAX(cast(total_deaths as int))/MAX(total_cases) as death_percentage
FROM covid_stats.dbo.covid_deaths
WHERE continent IS NOT NULL

--CTE
With pop_vaccs (continent, location, date, population, new_vaccinations, running_vaccs_total)
as
(
--Running Vaccination Total For each Country
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vaccs.new_vaccinations,
SUM(cast(vaccs.new_vaccinations as bigint)) OVER (Partition by deaths.location ORDER BY deaths.location, deaths.date) as running_vaccs_total
FROM covid_stats.dbo.covid_deaths as deaths
JOIN covid_stats.dbo.covid_vaccinations as vaccs
     ON deaths.location = vaccs.location
	 and deaths.date = vaccs.date
WHERE deaths.continent IS NOT NULL

)

SELECT *
FROM pop_vaccs
