Select *
From [Covid]..Deaths


-- change date format to Deaths
ALTER TABLE Deaths
Add newDate Date;

Select newDate
From [Covid]..Deaths


Select newDate, CONVERT(Date, date)
From [Covid]..Deaths


Update Deaths
SET newDate = CONVERT(Date, date )

ALTER TABLE Deaths
DROP COLUMN date;


Select *
From [Covid]..Vaccination

-- change date format Vaccination
ALTER TABLE Vaccination
Add newDate Date;

Select newDate, CONVERT(Date, date) as newDate
From [Covid]..Vaccination

Update Vaccination
SET newDate = CONVERT(Date, date)



-------------------- COUNTRIES --------------------------------
-- Countries with Highest Infection Rate compared to Population


Select Location, Population,  MAX(cast(total_cases as int)) as HighestInfectionCount,  MAX(cast(total_cases as int)/population)*100 as PercentPopulationInfected
From [Covid]..Deaths
Where continent is not null 
Group by Location, Population
order by Location 

-- Countries with Highest Death Count per Population

Select Location, Population, MAX(cast(total_deaths as int)) as TotalDeathCount,  Max(cast(total_deaths as int)/population)*100 as PercentTotalDeathCount
From [Covid]..Deaths
Where continent is not null 
Group by Location, Population
order by Location

-- Shows Percentage of Population that has recieved at least one Covid Vaccine
Select Location, Population, MAX(people_vaccinated) as HighestVaccinationCount,  Max((people_vaccinated/population))*100 as PercentPopulationVaccined
From [Covid]..Vaccination 
where continent is not null 
Group by Location, Population
order by 1,2



-------------------- CONTINENTS --------------------------------

-- Showing contintents with the highest morbidity per population

Select continent, sum(population) as total_population, SUM(new_cases) as total_cases
From [Covid]..Deaths
Where continent is not null 
Group by continent


-- Showing contintents with the highest death count per population

Select continent, sum(population) as total_population, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [Covid]..Deaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc


-- Showing contintents with the highest death count per population

Select continent, sum(population) as total_population, MAX(people_vaccinated) as HighestVaccinationCount
From [Covid]..Vaccination
Where continent is not null 
Group by continent
order by TotalDeathCount desc


-------------------- WORLD --------------------------------


-- Worldwide Death Percentage
Select sum(population) as total_population, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [Covid]..Deaths 

-- Worldwide Vaccination Percentage
Select sum(population) as total_population, SUM(CAST(people_vaccinated AS BIGINT))/sum(population)  as PrecentPopulationVaccined
From [Covid]..Vaccination

-------------------- POLAND --------------------------------


-- Looking at Total Cases vs Population
-- Show percentage of population get Covid


Select Location, newDate, total_cases, Population, (cast(total_cases as int)/Population)*100 as CovidPercentage
From [Covid]..Deaths
Where location like '%Poland%'
order by 1,2

-- Using CTE to perform Calculation on Partition By 

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.newDate, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (Partition by dea.Location Order by dea.location, dea.newDate) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Covid]..Deaths dea
Join [Covid]..Vaccination vac
	On dea.location = vac.location
	and dea.newDate = vac.newDate
where dea.location like '%Poland%'
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPopulationVaccinated
From PopvsVac
--- table with total cases and total vaccines

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.newDate, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (Partition by dea.Location Order by dea.location, dea.newDate) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Covid]..Deaths dea
Join [Covid]..Vaccination vac
	On dea.location = vac.location
	and dea.newDate = vac.newDate
where dea.location like '%Poland%'
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPopulationVaccinated
From PopvsVac


-- Percent Population Vaccined
Select Location, Population, MAX(people_vaccinated) as HighestVaccinationCount,  Max((people_vaccinated/population))*100 as PercentPopulationVaccined
From [Covid]..Vaccination 
where Location like '%Poland%'
Group by Location, Population
order by 1,2

-- Percent Population Infeccted
Select Location, Population, MAX(total_cases) as HighestVaccinationCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Covid]..Deaths
where Location like '%Poland%'
Group by Location, Population
order by 1,2
