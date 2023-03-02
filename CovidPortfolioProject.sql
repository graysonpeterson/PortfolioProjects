--Select data that we are going to be using
Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
Order by 1,2


--Looking at total cases vs. total deaths
--Shows the likelihood of dying if you contract COVID in your country
Select Location, date, total_cases, total_deaths, total_deaths/total_cases*100 as DeathPercentage
From CovidDeaths
Where location like '%states%'
Order by 1,2


--Looking at the total cases vs. the population
--Shows what percentage of population got COVID
Select Location, date, total_cases, population, (total_cases/population)*100 as SickPercentage
From CovidDeaths
Where location like '%states%'
Order by 1,2


--Looking at countries with highest infection rate compared to population
Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as SickPercentage
From CovidDeaths
Group by population, location
Order by SickPercentage DESC


--Showing the countries with highest death count per population
Select Location, MAX(total_deaths) as TotalDeathCount
From CovidDeaths
Where continent is not null
Group by location
Order by TotalDeathCount DESC


--LET'S BREAK THINGS DOWN BY CONTINENT

--Showing the continents with the highest death count per population
Select continent, MAX(total_deaths) as TotalDeathCount
From CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathCount DESC


--GLOBAL NUMBERS
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 as DeathPercentage
From CovidDeaths
Where continent is not null
--Group by date
Order by 1,2


--Looking at total population vs vaccinations
SELECT dea.continent, dea.[location], dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
    On dea.location = vac.location
    AND dea.date = vac.date
Where dea.continent is not null
Order by 2,3


--Use CTE
With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.[location], dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
    On dea.location = vac.location
    AND dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac



--TEMP TABLE
Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
    continent nvarchar(255),
    location NVARCHAR(255),
    Date DATETIME,
    population numeric,
    new_vaccinations numeric,
    RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.[location], dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
    On dea.location = vac.location
    AND dea.date = vac.date
--Where dea.continent is not null
--Order by 2,3
Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated


--Creating views to store data for later visualizations

--CREATE VIEW PercentPopVaccinated as 
SELECT dea.continent, dea.[location], dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
    On dea.location = vac.location
    AND dea.date = vac.date
Where dea.continent is not null

--CREATE VIEW DeathPercentage AS
Select Location, date, total_cases, total_deaths, total_deaths/total_cases*100 as DeathPercentage
From CovidDeaths
Where continent is not null

--CREATE VIEW TotalDeathCount as
Select Location, MAX(total_deaths) as TotalDeathCount
From CovidDeaths
Where continent is not null
Group by location