Select *
from [SQL projects].dbo.ultra

--How many states were represented in the race
SELECT COUNT(Distinct State) as Distinct_Count
from [SQL projects].dbo.ultra

--What was the average time of men VS women
Select Gender, AVG(TotalMinute) as AVG_Time 
from [SQL projects].dbo.ultra
group by Gender

--What were the youngest and oldest ages in the race
Select Gender, min(age) as youngest, max(age) as oldest
from [SQL projects].dbo.ultra
group by Gender

--Waht was the AVGE time fir each group

With age_buckets as (
SELECT TotalMinute, 
    case when age <30 then 'age_20-29'
	     when age <40 then 'age_30-29'
		 when age <50 then 'age_40-29'
		 when age <60 then 'age_50-29'
    else 'age 60+' end as age_group
from [SQL projects].dbo.ultra
)

Select  age_group, AVG(TotalMinute) as AVGE_Race_Time
from age_buckets
group by age_group

--Tope 3 males and female
With gender_rank as (
Select rank() over (partition by Gender order by TotalMinute asc) as gender_rank,
FullName, Gender, TotalMinute
from [SQL projects].dbo.ultra 
)
select *
from gender_rank
Where gender_rank < 4
order by TotalMinute

Select *
from dbo.VW_FF_50
from dbo.VW_FF_50