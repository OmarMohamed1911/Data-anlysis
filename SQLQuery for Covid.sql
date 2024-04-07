
--Take a qick look at the Whole data 
SELECT * 
FROM Deaths
where continent is not null

-- Select the data that I will be using
SELECT location, date, total_cases, total_deaths,population
from Deaths
order by 1,2

--Looking at the total cases VS total death
--Shwos likelihood ofdying if you contract covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from Deaths
WHERE location like '%Egypt%'
order by date 


--Looking at the Tottal cases VS population
--Shows what perecentage of populations got covid
SELECT location, date, total_cases, population, (total_deaths/population)*100 as death_percentage
from Deaths
WHERE location like '%Egypt%'
order by date DESC

--Looking at countries with highest infection rate compared to population

select location, population, max(total_cases) as highest_infection, MAX(total_cases/population)*100 as population_percentage
from Deaths
group by location, population
order by highest_infection DESC

--Showing countries with highst death count per population

select location, max(cast(total_deaths as int)) as total_deaths_count
from Deaths
--where location like'%Egypt%'
where continent is not null
group by location
order by total_deaths_count DESC

--Lets break things down by continent

--Showing continents with the highest death count per population
select continent,  max(cast(total_deaths as int)) as total_deaths_count
from Deaths
--where location like'%Egypt%'
where continent is not null
group by continent
order by total_deaths_count DESC


--Global numbers

SELECT date, SUM(new_cases) as sum_of_new_cases, SUM(new_deaths) as sum_of_new_deaths,  
 (SUM(cast(new_deaths as decimal))/SUM(new_cases))*100 as percentage_of_deaths
from Deaths
--WHERE location like '%Egypt%'
where continent is not null
group by date
order by date DESC


--Looking at total population VS vaccenations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over(partition by dea.location) as total_people_by_region
from Deaths as dea inner join Vaccinations as vac 
ON dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null	
order by vac.new_vaccinations desc


--USE CTE

with PopvsVac(continent, location, date, population, new_vaccinations, total_people_by_region)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as total_people_by_region
from Deaths as dea inner join Vaccinations as vac 
ON dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null	
--order by vac.new_vaccinations desc
)
Select *, (total_people_by_region/Population)*100 
From PopvsVac


--TEMP TABLE

Create table perecent_population_vaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
total_people_by_region numeric,
)



INSERT into perecent_population_vaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as total_people_by_region
from Deaths as dea inner join Vaccinations as vac 
ON dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null	
--order by vac.new_vaccinations desc

Select *, (total_people_by_region/Population)*100 
From perecent_population_vaccinated

--Creating view to store data for later visualizations 

Create view perecent_vaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as total_people_by_region
from Deaths as dea inner join Vaccinations as vac 
ON dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null	
--order by vac.new_vaccinations desc

SELECT *
from perecent_vaccinated
