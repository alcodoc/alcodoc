--Задание 4.1
select
    airports.city,
    count(distinct airports.airport_code) as count_airports
    -- считаем количество аэропортов в городе, результат  помещаем в новый столбец.
from
    dst_project.airports as airports
    -- присваиваем таблице короткое название для простоты работы.
group by
    airports.city
    -- группируем по городу для получения уникальных значений городов.
order by
    count_airports desc
    -- сортируем по убыванию, чтобы первыми оказались города с большим колич. аэропортов.

_______________________________________________________________________
--Задание 4.2
--Вопрос 1
select
    distinct status as count_status
from
    dst_project.flights


--Вопрос 2.
select
    count(flights.flight_id)
from
    dst_project.flights as flights
group by
    flights.status
having
    flights.status = 'Departed'


--Вопрос 3
select
    count(distinct seat_no)
from
    dst_project.aircrafts as a
        join dst_project.seats as s
            on a.aircraft_code = s.aircraft_code
where
    a.aircraft_code = '773'


--Вопрос 4
select
    count(f.status)
from
    dst_project.flights as f
where f.status != 'Cancelled'
    and f.status = 'Arrived'
    and f.actual_arrival between '2017-4-1, 0:00' and '2017-9-1, 24:00'

______________________________________________________________________

--Задание 4.3

--Вопрос 1
select
    count(f.status)
from
    dst_project.flights as f
where
    f.status = 'Cancelled'

--Вопрос 2
select
    a.model
from
    dst_project.aircrafts as a
order by a.model


--Вопрос 3
select
    substr(a.timezone,0, 5),
    -- берем субстроку - первые 4 символа для избавления от города.
    count(a.airport_code) as count_airport
from
    dst_project.airports as a
group by
    substr(a.timezone,0, 5)


--Вопрос 4
select
    max(f.actual_arrival - f.scheduled_arrival)
from
    dst_project.flights as f
-- находим максимальную задержку - '0 years 0 mons 0 days 5 hours 7 mins 0.00 secs'

--ЗАПРОС2:
select
    f.flight_id
from
    dst_project.flights as f

where (f.actual_arrival - f.scheduled_arrival) = '0 years 0 mons 0 days 5 hours 7 mins 0.00 secs'
-- находим id рейса с максимальной задержкой.

Ответ: 157571

_________________________________________________________________________________

--Задание 4.4

--Вопрос 1.
select
    min(f.scheduled_departure)
from
    dst_project.flights as f

--ОТВЕТ: август 14, 2016, 11:45 вечера


--Вопрос 2
select
    max(f.scheduled_arrival - f.scheduled_departure)
from
    dst_project.flights as f

--ОТВЕТ: 0 years 0 mons 0 days 8 hours 50 mins 0.00 secs = 530 мин

--Вопрос 3
select
    f.departure_airport,
    f.arrival_airport
from
    dst_project.flights as f

where (f.scheduled_arrival - f.scheduled_departure) = '0 years 0 mons 0 days 8 hours 50 mins 0.00 secs'
-- значение длительности рейса из предыдущего вопроса.

--ОТВЕТ: DME - UUS

--Вопрос 4
select
    avg(f.actual_arrival - f.actual_departure)
from
    dst_project.flights as f

--ОТВЕТ: 0 years 0 mons 0 days 2 hours 8 mins 21.128081 secs = 128 мин

__________________________________________________________________________

--Задание 4.5

--Вопрос 1
select
    count(s.seat_no),
    s.fare_conditions
from
    dst_project.seats as s
where
    s.aircraft_code = 'SU9'
group by
    s.fare_conditions

--ОТВЕТ: Economy


--Вопрос 2
select
    min(b.total_amount)
from
    dst_project.bookings as b

--ОТВЕТ: 3400

--Вопрос 3
select
    b.seat_no
from
    dst_project.tickets as t
        join dst_project.boarding_passes as b
            on t.ticket_no = b.ticket_no
where
    t.passenger_id = '4313 788533'

--ОТВЕТ: 2А

__________________________________________________________________________

--Задание 5.1

--Вопрос 1
select
    count(f.flight_id)
from
    dst_project.flights as f
where
    f.arrival_airport = 'AAQ'
    and actual_arrival between '2017-1-1, 0:00' and '2017-12-31, 24:00'
    and f.status = 'Arrived'

--ОТВЕТ: 486

--Вопрос 2
select
    count(f.flight_id)
from
    dst_project.flights as f
where
     f.departure_airport = 'AAQ'
    and actual_departure between '2017-1-1, 0:00' and '2017-2-28, 24:00'

--ОТВЕТ: 127

--Вопрос 3
select
    count(f.flight_id)
from
    dst_project.flights as f
where
     f.departure_airport = 'AAQ'
    and f.status = 'Cancelled'

--ОТВЕТ: 1

--Вопрос 4
select
   count(distinct f.flight_id)
from
    dst_project.flights as f
        join dst_project.airports as a
            on f.arrival_airport = a.airport_code
where
    f.departure_airport = 'AAQ' and a.city != 'Moscow'

--ОТВЕТ: 453

--Вопрос 5
select
    a.model, count(distinct s.seat_no) as count_seat
from dst_project.flights as f
    join dst_project.aircrafts as a on f.aircraft_code = a.aircraft_code
        join dst_project.seats as s on a.aircraft_code = s.aircraft_code
where
    f.departure_airport = 'AAQ'
group
    by a.model
order by
    count_seat desc
limit
    1

--ОТВЕТ: Boeing 737-300


_________________________________________________________
--Запрос для создания датасета к проекту.

select
    f.flight_id,
    f.scheduled_departure,
    ap1.city as city_departure,
    ap.city as city_arrival,
    ac.model as aircraft_model,
    tf.fare_conditions,
    count(distinct s.seat_no) as available_seats,
    -- компоновка самолета по количеству мест разного класса обслуживания
    avg(tf.amount) as price_seat,
    -- цена одного места
    count(distinct bp.seat_no) as occupied_seats,
    -- количество проданных мест
    count(distinct bp.seat_no) * 100 / nullif(count(distinct s.seat_no),0)
        as fullness_flight,
    -- заполненность мест в самолете на рейсе
    -- nullif используется из-за нулевых значений в рейсах на Новокузнецк
    count(distinct bp.seat_no) * avg(tf.amount) as revenue_flight,
    -- выручка от проданных билетов по каждому классу отдельно
    count(distinct s.seat_no) - count(distinct bp.seat_no) as free_seats,
    -- нераспроданные места
    count(distinct s.seat_no) * avg(tf.amount) - count(distinct bp.seat_no)
        * avg(tf.amount) as lost_profit
    -- упущенная выгода по каждому классу

from
    dst_project.flights as f
        join dst_project.airports as ap
            on f.arrival_airport = ap.airport_code
        join dst_project.airports as ap1
            on f.departure_airport = ap1.airport_code
        join dst_project.aircrafts as ac
            on f.aircraft_code = ac.aircraft_code
        left join dst_project.ticket_flights as tf
            on f.flight_id = tf.flight_id
        left join dst_project.boarding_passes as bp
            on tf.ticket_no = bp.ticket_no
                and tf.flight_id = bp.flight_id
        left join dst_project.tickets as t
            on tf.ticket_no = t.ticket_no
        left join dst_project.bookings as b
            on t.book_ref = b.book_ref
        left join dst_project.seats as s
            on ac.aircraft_code = s.aircraft_code
                and s.fare_conditions = tf.fare_conditions
    /* В запросе объединены все таблицы из базы данных dst_project. Эту конструкцию
    можно использовать для написания других запросов к этой базе данных, если
    понадобится дополнительная информация. Однако в итоговый датасет включена
    информация не из всех таблиц, так как для ответа на поставленный вопрос она
    будет избыточной. Кроме того отказ от всей полноты базы данных дал возможность
    сгруппировать нужную информацию и представить ее в удобном виде, который не
    требует дополнительной обработки на Python.

    Начиная с таблицы Ticket_flights присоединяем последующие таблицы по left join,
    так как в базе данных имеются ресы в Новокузнецк, по которым нет данных о продаже
    билетов. */

where f.departure_airport = 'AAQ'
    and (date_trunc('month', f.scheduled_departure) in ('2017-01-01','2017-02-01', '2017-12-01'))
    and f.status not in ('Cancelled')
    -- Условия проекта: выполненные зимой 2017 года рейсы из Анапы.
group by
    f.flight_id,
    f.scheduled_departure,
    ap1.city,
    ap.city,
    ac.model,
    tf.fare_conditions,
    s.fare_conditions


    _________________________________________________________________________________________


/*ЗАПРОС для получения справочной информации о предельной дальности полета модели самолета
и средней продолжительности полетов от Анапы до Москвы, Белгорода и Новокузнецка.
Эта информация одинакова для всех рейсов в указанные города, имеет справочный характер,
поэтому нет смысла перегружать ею основной датасет. Информация о расстоянии между
аэропортами также носит справочный характер и общедоступна, поэтому нет смысла расчитывать
ее по координатам аэропортов.*/

select
    --f.flight_id,
    ap1.city as city_departure,
    ap.city as city_arrival,
    ac.model as aircraft_model,
    ac.range,
    avg(f.actual_arrival - f.actual_departure) as flight_time

from
    dst_project.flights as f
        join dst_project.airports as ap on f.arrival_airport = ap.airport_code
        join dst_project.airports as ap1 on f.departure_airport = ap1.airport_code
        join dst_project.aircrafts as ac on f.aircraft_code = ac.aircraft_code

where f.departure_airport = 'AAQ'
    and (date_trunc('month', f.scheduled_departure) in ('2017-01-01','2017-02-01', '2017-12-01'))
    and f.status not in ('Cancelled')

group by
    ap1.city,
    ap.city,
    ac.model,
    ac.range
