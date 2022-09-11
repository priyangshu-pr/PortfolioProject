
/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/


select * from dbo.CovidDeaths where continent is not null and location like  'india' order by 3,4

select * from dbo.CovidVaccinations  order by 3,4 

-- 1) showing likelihood of death if you contract covid in your country (I belong from India)

select iso_code, continent, location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as percentageDeath from dbo.CovidDeaths
where continent is not null  and location like 'India' order by 3,4

-- 2) showing what percentage of population infected with covid in your country

select iso_code, continent, location, date, total_cases, population, (total_cases/population)*100 as percentageCases from dbo.CovidDeaths 
where  continent is not null and location like 'India' order by 3,4

-- 3) Countries with highest infection rate compared to population

select location,MAX(total_cases) as MAXcaseOfCountry ,population, (MAX(total_cases)/population)*100 as percentageMaxCASE from dbo.CovidDeaths
where continent is not null  group by location, population order by percentageMaxCASE desc

-- 4) Countries with highest death count compared to population

select location, MAX(cast(total_deaths as int)) as MAXdeathCountry,population,MAX(cast(total_deaths as int))/population*100 as percentageDEATH from dbo.CovidDeaths
where continent is not null group by location ,population order by MAXdeathCountry desc 

-- 5)Showing continent with highest death count per population

select continent, max(cast(total_deaths as int))as totalDeathCount, max(cast(total_cases as int))as totalCaseCount from dbo.CovidDeaths 
where continent is not null group by continent order by totalDeathCount desc

--6)Showing percentage of population who get vaccinated atleast once each day.

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated,
(sum(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date)/dea.population)*100 as percentagePopulationVaccinated
From dbo.CovidDeaths dea Join dbo.CovidVaccinations vac On dea.location = vac.location and dea.date = vac.date
where dea.continent is not null order by 2,3


--7)Creating View to store data for later visualizations

drop view percentagePeopleVaccinated 
create view percentagePeopleVaccinated as

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated,
(sum(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date)/dea.population)*100 as percentagePopulationVaccinated
From dbo.CovidDeaths dea Join dbo.CovidVaccinations vac On dea.location = vac.location and dea.date = vac.date
where dea.continent is not null

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------