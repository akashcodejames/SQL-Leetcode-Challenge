-- Question 107
-- The Numbers table keeps the value of number and its frequency.

-- +----------+-------------+
-- |  Number  |  Frequency  |
-- +----------+-------------|
-- |  0       |  7          |
-- |  1       |  1          |
-- |  2       |  3          |
-- |  3       |  1          |
-- +----------+-------------+
-- In this table, the numbers are 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, so the median is (0 + 0) / 2 = 0.

-- +--------+
-- | median |
-- +--------|
-- | 0.0000 |
-- +--------+
-- Write a query to find the median of all numbers and name the result as median.

-- Solution


with cte as 
(select * , sum(frequency) over(order by number rows between unbounded preceding and current row ) as m1 from mytable
),cte2 as(
select max(m1) as j1 from cte),
cte3 as(
select case when (select j1 from cte2) %2=0 then (select j1 from cte2)/2 else -1 end as h1, case when (select j1 from cte2) %2=0 then (select j1 from cte2)/2 + 1 else -1 end as h2, case when (select j1 from cte2) %2=1 then ceil((select j1 from cte2)/2) ELSE -1 end as h3
),cte4 as(
select *,COALESCE(lag(m1,1) over() ,0) as e1 from cte
),cte5 as (
select number,frequency from cte4 where (select h1 from cte3) between e1+1 and m1 or (select h2 from cte3) between e1+1 and m1 or (select h1 from cte3) between e1 and m1
)
select round(sum(number)/count(*),2) as d1 from cte5

or 

with t1 as(
select *,
sum(frequency) over(order by number) as cum_sum, (sum(frequency) over())/2 as middle
from numbers)

select avg(number) as median
from t1
where middle between (cum_sum - frequency) and cum_sum
