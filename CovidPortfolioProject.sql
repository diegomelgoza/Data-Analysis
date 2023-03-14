Select * From PortfolioProject..CovidDeaths$
Where continent is not null
Order By 3,4

--Select * From PortfolioProject..CovidVaccinations$
--Order By 3,4

-- Select Data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths$
Order By 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows the likelyhood of dying when contracting covid in your country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
From PortfolioProject..CovidDeaths$
Where location = 'United States'
Order By 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got covid
Select location, date, population, total_cases, (total_cases/population)*100 As PercentPopulationInfected
From PortfolioProject..CovidDeaths$
Where location = 'United States'
Order By 1,2

-- Looking at countries with highest infection rate compared to population

Select location, population, MAX(total_cases) As HighestInfectionCount, MAX((total_cases/population))*100 As PercentPopulationInfected
From PortfolioProject..CovidDeaths$
--Where location = 'United States'
Group By location, population
Order By PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population

Select location, MAX(cast(total_deaths as int)) As TotalDeathCount
From PortfolioProject..CovidDeaths$
-- Put this where statement because locations was providing continents instead of countries
Where continent is not null
Group By location
Order By TotalDeathCount desc

-- Showing Continents with Highest Death Count per Population

Select location, MAX(cast(total_deaths as int)) As TotalDeathCount
From PortfolioProject..CovidDeaths$
-- Put this where statement because locations was providing continents instead of countries
Where continent is null
Group By location
Order By TotalDeathCount desc

-- Global Numbers

Select date, SUM(new_cases) As total_cases, SUM(CAST(new_deaths as int)) As total_deaths, (SUM(CAST(new_deaths as int))/SUM(new_cases))*100 As DeathPercentage
From PortfolioProject..CovidDeaths$
Where continent is not null
Group By date
Order By 1,2

-- Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(Convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
	-- Can't use below here because this column was just created so you must use a CTE or temp table in order to use the calculation below
	--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null
Order By 2,3

-- Looking at Total Population vs Vaccinations continued...
-- USING CTE to see the following query: (RollingPeopleVaccinated/population)*100 
With PopvsVac (Continent, location, date, population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
		SUM(Convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
	From PortfolioProject..CovidDeaths$ dea
	Join PortfolioProject..CovidVaccinations$ vac
		On dea.location = vac.location 
		and dea.date = vac.date
	Where dea.continent is not null
	--Order By 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(Convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null
--Order By 2,3