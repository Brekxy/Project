
select *
from ProjectPortfolio..CovidDeaths
where continent is not null
order by 3,4

--select *
--from ProjectPortfolio..CovidVaccinations
--order by 3,

--selecting data that i am going tobe using

select location, date,  total_cases, new_cases, total_deaths, population
from ProjectPortfolio..CovidDeaths
where continent is not null
order by 1,2

--looking at the total cases vs total deaths
--likelihood of dying if the virus is contracted

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from ProjectPortfolio..CovidDeaths
where location = 'nigeria'
and continent is not null
order by 1,2

--looking at total cases vs population
--shows what percentage of population got covid

select location, date, population, total_cases, (total_cases/population)*100 as PercentageofPopulationInfected
from ProjectPortfolio..CovidDeaths
--where location = 'nigeria'
order by 1,2


--countries with the hit infection rate

select location, population, max(total_cases) as HighestInfectionCount, max(total_cases/population)*100 as PercentageofPopulationInfected
from ProjectPortfolio..CovidDeaths
--where location = 'nigeria'
group by location, population
order by PercentageofPopulationInfected desc


--By continent

--Countries with highest death count per population

select location, max(cast(total_deaths as int)) as TotalDeathCount
from ProjectPortfolio..CovidDeaths
--where location = 'nigeria'
where continent is not null
group by location
order by TotalDeathCount desc

--By continent

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from ProjectPortfolio..CovidDeaths
--where location = 'nigeria'
where continent is not null
group by continent
order by TotalDeathCount desc


--Global numbers

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int)) / sum(new_cases) *100 as DeathPercentage
from ProjectPortfolio..CovidDeaths
--where location = 'nigeria'
where continent is not null
--Group by date
order by 1,2



--looking at total  population vs vacccination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from ProjectPortfolio..CovidDeaths dea
join ProjectPortfolio..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	order by 2,3


	--Using CTE

with PopsvsVac (continent, location, date, population, New_vaccinations, RollingPeopleVaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from ProjectPortfolio..CovidDeaths dea
join ProjectPortfolio..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 2,3
)
select*, (RollingPeopleVaccinated/population)*100
from PopsvsVac








--TEMP TABLE

create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from ProjectPortfolio..CovidDeaths dea
join ProjectPortfolio..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 2,3

select*, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated



drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from ProjectPortfolio..CovidDeaths dea
join ProjectPortfolio..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	--where dea.continent is not null
	--order by 2,3

select*, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated




--creating view to store data for later visualizations

Create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from ProjectPortfolio..CovidDeaths dea
join ProjectPortfolio..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 2,3

	SELECT*
	from PercentPopulationVaccinated

