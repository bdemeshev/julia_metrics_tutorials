### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ f354c7da-63b5-11eb-154d-0191edfd3c93
begin
	using Pkg
	Pkg.add(["DataFrames", "RDatasets"])
	
	using DataFrames
	using RDatasets
end

# ╔═╡ 23ae525c-63bb-11eb-31d1-cdc26c21546b
begin
	Pkg.add(["DataFramesMeta", "Query"])

	using DataFramesMeta
	using Query
end

# ╔═╡ b9b81dfc-63be-11eb-2982-29f73ad29cf2
using Statistics

# ╔═╡ 9e6e4bce-63b5-11eb-3e5a-0912e0975882
md"# Работа с датафреймами на Julia"

# ╔═╡ c24bea42-63b5-11eb-1aad-cd94dc0c4679
md"## Создание датафрейма"

# ╔═╡ d070c570-63b5-11eb-1946-bd81d539224e
md"Для начала скачаем датасеты из R и пакет DataFrames для работы с ними:"

# ╔═╡ 1a7d0f34-63b6-11eb-2d21-735f0df9ad0f
md"Сохраняем датасет diamonds как DataFrame:"

# ╔═╡ 57bbbd5a-63b6-11eb-177a-edd02c67a162
diamonds = dataset("ggplot2", "diamonds")

# ╔═╡ 27e1ebc6-63b7-11eb-1d1d-9b2c6c337410
md"Функции first и last позволяют вывести на экран первые и последние строки датафрейма соответственно:"

# ╔═╡ 3b03aa00-63b7-11eb-1412-1b4ed91ec1ff
first(diamonds, 5)

# ╔═╡ 4e6f3802-63b7-11eb-3046-a15ea8996d7a
 last(diamonds, 5)

# ╔═╡ 5977749e-63b7-11eb-314c-0f803af2384d
md"## Выбор отдельных столбцов"

# ╔═╡ 6a54d3ec-63b7-11eb-3ae3-b5c85d118271
md"По названию стобцы могут быть выбраны одним из следующих способов:"

# ╔═╡ a642aa28-63b7-11eb-1087-05b49af3a8f9
diamonds.Carat

# ╔═╡ d03a4eba-63b7-11eb-3d33-4383c57dcbbb
diamonds."Carat"

# ╔═╡ d8239908-63b7-11eb-1c7d-0d1a01f91907
diamonds[!, :Carat]

# ╔═╡ e22ebc02-63b7-11eb-0eb0-91077a72127d
diamonds[!, "Carat"]

# ╔═╡ f518b20a-63b7-11eb-3471-b336d3d7e887
md"Поскольку df[!, :col] не создает копию, изменение элементов получаемого таким способом вектора приводит к изменению значений в исходном df."

# ╔═╡ 0a0fba6e-63b8-11eb-2deb-d97aa7162d23
begin
	vec = diamonds[!, "Carat"]
	vec[1] = 111 # изменяем первое значение вектора на 111
	vec
end

# ╔═╡ 209a82d0-63b8-11eb-07cc-eb324848c7af
 first(diamonds, 5) # значение в df не изменилось на 111

# ╔═╡ 2bfebcd8-63b8-11eb-1ba5-7bae39541004
md"Для создания копии столбца надо использовать df[:, :col] , изменение полученного вектора не будет влиять на исходный df:"

# ╔═╡ 3a2c2502-63b8-11eb-0269-4f17ae7948d1
begin
	vec2 = diamonds[:, "Carat"]
	vec2[1] = 222 # изменяем первое значение вектора на 222
	vec2
end

# ╔═╡ 4e022a7a-63b8-11eb-1d81-b99f33e6de2e
first(diamonds, 5) # значение в df не изменилось на 222

# ╔═╡ 61578892-63b8-11eb-060f-bffb99a079f6
diamonds[1, 1] = 0.23 # вернем исходное значение

# ╔═╡ 6e273bb2-63b8-11eb-0859-25605875e8bd
md"## Выбор подмножества датафрейма"

# ╔═╡ 7ca723d2-63b8-11eb-3482-df3ad4448ca7
md"Можно выбрать подмножество датафрейма с помощью индексов. Двоеточие : означает, что
нужно выбрать все элементы (строки или столбца, в зависимости от позиции)."

# ╔═╡ 87f55de4-63b8-11eb-394a-5fde7ade3192
diamonds[2:10, :]

# ╔═╡ 912f32c0-63b8-11eb-2bdd-f540663f6e66
diamonds[[1, 5, 10], :]

# ╔═╡ a4f9c902-63b8-11eb-20c6-f5b161e12ae3
diamonds[3:6, ["Carat", "Color", "Cut"]]

# ╔═╡ b7c21206-63b8-11eb-1b7d-39ed5f2a1ae1
diamonds[10:15, [:Carat, :Color, :Cut]]

# ╔═╡ c902c736-63b8-11eb-1427-f7168b69de43
md"Стоит отметить, что df[:, [:col]] и df[!, [:col]] возвращают объект DataFrame, а df[:, :col] и df[!, :col] - вектор:"

# ╔═╡ db91a390-63b8-11eb-13ab-2b7680a2114b
diamonds[:, [:Carat]]

# ╔═╡ ecdd9186-63b8-11eb-331c-cf9af704178c
diamonds[:, :Carat]

# ╔═╡ f7882602-63b8-11eb-0c90-f14fc95e323f
md"Селектор Not позволяет выбрать все столбцы, кроме обозначенного подмножества:"

# ╔═╡ 04e3bfda-63b9-11eb-1411-917898a9416b
diamonds[1:5, Not("Carat")]

# ╔═╡ 16882e1a-63b9-11eb-08b4-673fd8d60167
diamonds[1:5, Not(["Carat", "Cut"])]

# ╔═╡ 293aa204-63b9-11eb-3377-df1c4e6b9aa3
md"Селектор Between позволяет выбрать все столбцы между указанными:"

# ╔═╡ 3458fef6-63b9-11eb-043e-7950b0d1ce4b
diamonds[1:5, Between("X", "Z")]

# ╔═╡ 41bfbfce-63b9-11eb-3315-f1ad0a828c67
md"С помощью индексов можно осуществлять выбор наблюдений (строк), удовлетворяющих
условиям на значения переменных (столбцов):"

# ╔═╡ 4aceb928-63b9-11eb-38a9-0f4ec57d95f6
diamonds[diamonds.Carat .> 0.5, :] # все наблюдения со значением "Carat" строго больше 0.5

# ╔═╡ 5a022d9e-63b9-11eb-0b0a-3dc16ed2b1ce
# все наблюдения, где "Carat" строго больше 0.5 и "Price" строго меньше 2500
diamonds[(diamonds.Carat.> 0.5) .& (diamonds.Price .<2500) , :]

# ╔═╡ 734f54de-63b9-11eb-27c5-a135601ba3ad
# все наблюдения, где "Carat" строго больше 0.5 и значение "Cut" равно "Ideal"
diamonds[(diamonds.Carat.> 0.5) .& (diamonds.Cut .== "Ideal") , :]

# ╔═╡ 8be7b8c4-63b9-11eb-0e5d-effb5856e5ce
# все наблюдения, где "Carat" строго больше 0.5 или "Price" строго больше 2750
diamonds[(diamonds.Carat .> 0.5) .| (diamonds.Price .> 2750), :]

# ╔═╡ 9e4b1012-63b9-11eb-33bb-d766e60e61e2
md"## Работа со столбцами"

# ╔═╡ d19b6690-63b9-11eb-362b-550e7e0bb190
md"### select, select!, transform и transform!"

# ╔═╡ dcd6f150-63b9-11eb-19a4-0304f869203a
md"С помощью функций select и select! можно осуществлять выбор, переименование и
транформацию столбцов датафрейма."

# ╔═╡ e6fa7cba-63b9-11eb-0770-6d2cdd08cf6d
md"Функция select создает новый объект DataFrame. Она всегда возвращает объект DataFrame, даже если выбран только один столбец:"

# ╔═╡ fb3a1a52-63b9-11eb-0bc6-e1fba2ada82f
select(diamonds, :Carat) # датафрейм с одним столбцом

# ╔═╡ 088dea6a-63ba-11eb-2aea-8bd4410071b3
select(diamonds, ["Carat", "Cut", "Price"]) # выбор нескольких указанных столбцов

# ╔═╡ 1584a62a-63ba-11eb-1ccf-1b8651770f75
select(diamonds, Not(["Clarity", "Color"])) # выбор всех столбцов, кроме указанных

# ╔═╡ 21b772fe-63ba-11eb-287a-b36c72b79084
select(diamonds, Between("Carat", "Price")) # выбор диапазона столбцов

# ╔═╡ 2f0f250a-63ba-11eb-187f-b1c93806addb
# переименование столбцов
select(diamonds, "Carat" => "Карат", "Price" => "Цена", "Cut" => "Огранка")

# ╔═╡ 50de6d94-63ba-11eb-0b43-ed16faff9dd8
# трансформация столбца
select(diamonds, "Price", "Price" => (x -> log.(x)) => "LogPrice")

# ╔═╡ 68064a0c-63ba-11eb-3bbf-17fa3851f382
# альтернативный способ сделать то же самое
select(diamonds, "Price", "Price" => ByRow(log))

# ╔═╡ 7659aca0-63ba-11eb-2efe-3d952047ee7d
md"Чтобы не создавать копию датафрейма, можно использовать функцию select!"

# ╔═╡ 7faeaeb6-63ba-11eb-103c-cbb4fbf4f24b
md"(для изменений inplace)"

# ╔═╡ 89a7418c-63ba-11eb-2e20-1fac8245672d
md"Функции transform и transform! работают аналогично select и select!. Единственное
отличие - сохраняются все исходные столбцы:"

# ╔═╡ 99a30cb0-63ba-11eb-04b2-f9e62b4bfb98
# добавляем новый столбец (логарифм цены) в исходный датафрейм
transform!(diamonds, "Price" => ByRow(log))

# ╔═╡ b179754a-63ba-11eb-3c7b-55e009489380
diamonds # в датафрейм добавился столбец

# ╔═╡ bc086efa-63ba-11eb-065f-cd5ff0803f53
md"# Фреймворки для работы с данными и запросами"

# ╔═╡ c94842d2-63ba-11eb-1249-dd3341cdcd1a
md"## DataFramesMeta"

# ╔═╡ d193b4bc-63ba-11eb-2bc4-63ec49ef1d71
md"Догрузим и запустим необходимые пакеты:"

# ╔═╡ 63cfff56-63bc-11eb-322b-8329cb04fded
md"Рассматриваемый пакет предоставляет короткий способ вызова столбцов DataFrame."

# ╔═╡ 7635a9d4-63bc-11eb-2b6a-2f2e1ffb6b6a
md"Вызов столбца тут осуществляется только по его названию. Помимо этого можно создавать цепи вызовом макроса @linq: оператор |> подает результат вычисления предыдущего шага на вход в следующее выражение. Например:"

# ╔═╡ b6547496-63bc-11eb-3f77-034e29bdd11d
@linq diamonds |>
	where(:Price .> 500) |>
	select(Mass=:Carat, :Price)

# ╔═╡ c13e21ae-63bc-11eb-0323-f58fa9e7783a
md"Данный фреймворк также позволяет делить данные из исходного датасета на группы вычислять функции от групп, комбинировать полученные результаты."

# ╔═╡ cf752a42-63bc-11eb-0450-51a28f855353
md"Например, для группировки качественных данных (типа CategoricalValue) можно использовать функцию sort(), а для создания нового столбца на основе имеющихся – функцию transform(). Чтобы применить функцию ко всему столбцу (поточечно) непосредственно после ее названия нужно поставить знак точки:"

# ╔═╡ dcfd4b72-63bc-11eb-29ba-e5a7fa7ee50d
@linq diamonds |>
	sort(:Cut) |>
	transform(LogRatio = log.(:Price ./ :Carat))

# ╔═╡ e7a9393c-63bc-11eb-0da9-ad6ab03f30f3
md"## Query"

# ╔═╡ f9441f54-63bc-11eb-1273-affc5e83fde8
md"Другой способ извлекать необходимые паттерны из датасета – пакет для обработки запросов Query."

# ╔═╡ 05d1599e-63bd-11eb-1899-d387dfe903cf
md"Запрос начинается с макроса @from. Первый аргумент – это переменная, пробегающая строки таблицы, второй – непосредственно запрашиваемая таблица."

# ╔═╡ 107934c0-63bd-11eb-309d-1f3c517deb3c
md"Команда @where отфильтровывает строки, для которых значение в указанном столбце не
удовлетворяет заданному условию."

# ╔═╡ 1dc4a2ae-63bd-11eb-235c-1fd93d071330
md"Команда @select сохраняет требуемые данные в новый столбец. Чтобы выход имел вид таблицы следует использовать {}."

# ╔═╡ 23a47848-63bd-11eb-0519-b9d191b54902
md"При помощи команды @collect можно задать тип объекта, желаемый получить в качестве ответа на запрос (по умолчанию возвращается iterator)."

# ╔═╡ 2ea3cf80-63bd-11eb-10bf-910fd48c9ba0
md"Тело запроса (часть кода после @from) начинается с команды begin и заканчивается командой end."

# ╔═╡ 3985089e-63bd-11eb-38e8-a7dab8fa51d6
md"Выполним те же операции, что и в предыдущем разделе, но с ипользованием фреймворка
Query:"

# ╔═╡ 44604774-63bd-11eb-0228-81c4346b1d16
q1 = @from i in diamonds begin
	@where i.Price > 500
	@select {Mass=i.Carat, i.Price}
	@collect DataFrame
end

# ╔═╡ 53069b3e-63bd-11eb-2b7f-5baf50ae000d
md"Вызов команды @collect без указания типа данных вернет ответ на запрос в формате array:"

# ╔═╡ 5be87394-63bd-11eb-33ec-cda3cfcae091
q2 = @from i in diamonds begin
	@where i.Price > 500 && i.Carat > 0.5
	@select i.Price
	@collect
end

# ╔═╡ 6c6f26ac-63bd-11eb-0350-57481a29969f
md"# Summarizing"

# ╔═╡ 6916c56a-63be-11eb-3fb4-fbf373f00a61
md"Команда describe показывает статистическую информацию о датафрейме, среди которой такие значения: среднее, минимальное, максимальное значения, медиана, количество пропусков, тип переменной:"

# ╔═╡ 7e4b52f0-63be-11eb-35b0-5b05e05e6136
describe(diamonds)

# ╔═╡ 86ea35e0-63be-11eb-2fe2-3dcd50b8e279
md"Данную команду можно применить также не только к целому датафрейму, но и к его отдельной части, например:"

# ╔═╡ 9d718ab6-63be-11eb-1e39-350dd83b1cf3
describe(diamonds[!, [:Cut]])

# ╔═╡ a8b3c574-63be-11eb-27de-3515fec4c748
md"Также с помощью пакета Statistics можно найти статистические значения для отдельного столбца. Например, среднее:"

# ╔═╡ c5be9950-63be-11eb-0404-0f06dd409a46
mean(diamonds[!, "Carat"]) #среднее

# ╔═╡ cdf71a48-63be-11eb-2c94-db3981fcfe15
md"Аналогично можно найти другие значения:"

# ╔═╡ d64eb566-63be-11eb-36df-a16db49233ac
median(diamonds[!, "Price"]) #медиана

# ╔═╡ e07ea2b2-63be-11eb-1a8f-55af47d59a88
maximum(diamonds[!, "Price"]) #максимум

# ╔═╡ e8143922-63be-11eb-3a93-4bf933abe948
minimum(diamonds[!, "Price"]) #минимум

# ╔═╡ ee11aece-63be-11eb-24d9-1d4b90a7a6b9
md"Функция combine позволяет применять функцию к отдельному столбцу. Например, следующим образом:"

# ╔═╡ fe101e5a-63be-11eb-20d7-7147d3d6afdb
combine(diamonds, :Price .=> sum) #сумма по столбцу

# ╔═╡ 05c3c7dc-63bf-11eb-1620-a90dbedf4157
combine(diamonds, :Price => maximum) #максимальное значение по столбцу

# ╔═╡ 0c46b7cc-63bf-11eb-061a-31586565022d
md"Select позволяет получить тот же результат, только на выходе дает то же число строк, которое изначально в датафрейме:"

# ╔═╡ 1677f7e2-63bf-11eb-059f-83ea78ead39f
select(diamonds, :Price => maximum) #максимальное значение по столбцу

# ╔═╡ 226fbada-63bf-11eb-3cd0-5d07d6c8c1e8
md"# Работа со столбцами"

# ╔═╡ c1d18022-63bf-11eb-21a9-876544dd3553
md"Все функции, которые меняют датафрейм по умолчанию копируют его столбцы. Так, например:"

# ╔═╡ cd273b24-63bf-11eb-3126-1f37ce4cdc6e
diamonds2 = copy(diamonds)

# ╔═╡ df2ce4de-63bf-11eb-1f00-c78758bb98e3
diamonds2.Price === diamonds.Price

# ╔═╡ ee638900-63bf-11eb-250a-53ed8a5523cd
md"Тем не менее, будьте осторожны! Функции, которые заканчиваются символом ! могут изменить столбец, который ей скормили в качестве аргумента. Обратите внимание, к примеру, на такую ситуацию:"

# ╔═╡ 17a3d89c-63c0-11eb-2ae1-ebd583514f0e
price = diamonds.Price

# ╔═╡ 203bc4e2-63c0-11eb-33fb-9bc93e0fd74f
df = DataFrame(price=price)

# ╔═╡ 285682fc-63c0-11eb-064e-2b34fafa81ce
sort!(df)

# ╔═╡ 3e0eebb4-63c0-11eb-3168-edbe95b535cb
price

# ╔═╡ 4a7e4a16-63c0-11eb-169a-fbcb1fc5c874
df.price[1] = 100

# ╔═╡ 5215f69a-63c0-11eb-0947-bf7b827cb4cd
df

# ╔═╡ 5a8d0dae-63c0-11eb-2a3b-83519757fae9
price

# ╔═╡ 60fbe23a-63c0-11eb-0090-1b7c7c60af19
md"Как Вы могли заметить, в указанном выше примере вектор цен price, взятый из таблицы diamonds не был изменён, так как конструктор DataFrame(price=price) по умолчанию создаёт копию."

# ╔═╡ 6b3d3160-63c0-11eb-0ac0-8388c4d47603
md"Тем не менее, если Вам вдруг понадобится обратиться напрямую к некоторому столбцу датафрейма, это возможно сделать при помощи функции eachcol."

# ╔═╡ 7875630c-63c0-11eb-241f-cb8e76e78df1
df2 = DataFrame(price=price)

# ╔═╡ 8181233c-63c0-11eb-2828-87b66090b047
df2.price == price

# ╔═╡ 896d9526-63c0-11eb-2f0e-f790d633ce92
df2[!, 1] !== price

# ╔═╡ 912a93a4-63c0-11eb-0e3b-bfc907b230cc
eachcol(df2)[1] === df2.price

# ╔═╡ 985256f8-63c0-11eb-2856-b975188c3fa1
md"Будьте осторожны, когда меняете столбцы из датафрейма таким способом!"

# ╔═╡ Cell order:
# ╟─9e6e4bce-63b5-11eb-3e5a-0912e0975882
# ╟─c24bea42-63b5-11eb-1aad-cd94dc0c4679
# ╟─d070c570-63b5-11eb-1946-bd81d539224e
# ╠═f354c7da-63b5-11eb-154d-0191edfd3c93
# ╟─1a7d0f34-63b6-11eb-2d21-735f0df9ad0f
# ╠═57bbbd5a-63b6-11eb-177a-edd02c67a162
# ╟─27e1ebc6-63b7-11eb-1d1d-9b2c6c337410
# ╠═3b03aa00-63b7-11eb-1412-1b4ed91ec1ff
# ╠═4e6f3802-63b7-11eb-3046-a15ea8996d7a
# ╟─5977749e-63b7-11eb-314c-0f803af2384d
# ╟─6a54d3ec-63b7-11eb-3ae3-b5c85d118271
# ╠═a642aa28-63b7-11eb-1087-05b49af3a8f9
# ╠═d03a4eba-63b7-11eb-3d33-4383c57dcbbb
# ╠═d8239908-63b7-11eb-1c7d-0d1a01f91907
# ╠═e22ebc02-63b7-11eb-0eb0-91077a72127d
# ╟─f518b20a-63b7-11eb-3471-b336d3d7e887
# ╠═0a0fba6e-63b8-11eb-2deb-d97aa7162d23
# ╠═209a82d0-63b8-11eb-07cc-eb324848c7af
# ╟─2bfebcd8-63b8-11eb-1ba5-7bae39541004
# ╠═3a2c2502-63b8-11eb-0269-4f17ae7948d1
# ╠═4e022a7a-63b8-11eb-1d81-b99f33e6de2e
# ╠═61578892-63b8-11eb-060f-bffb99a079f6
# ╟─6e273bb2-63b8-11eb-0859-25605875e8bd
# ╟─7ca723d2-63b8-11eb-3482-df3ad4448ca7
# ╠═87f55de4-63b8-11eb-394a-5fde7ade3192
# ╠═912f32c0-63b8-11eb-2bdd-f540663f6e66
# ╠═a4f9c902-63b8-11eb-20c6-f5b161e12ae3
# ╠═b7c21206-63b8-11eb-1b7d-39ed5f2a1ae1
# ╟─c902c736-63b8-11eb-1427-f7168b69de43
# ╠═db91a390-63b8-11eb-13ab-2b7680a2114b
# ╠═ecdd9186-63b8-11eb-331c-cf9af704178c
# ╟─f7882602-63b8-11eb-0c90-f14fc95e323f
# ╠═04e3bfda-63b9-11eb-1411-917898a9416b
# ╠═16882e1a-63b9-11eb-08b4-673fd8d60167
# ╟─293aa204-63b9-11eb-3377-df1c4e6b9aa3
# ╠═3458fef6-63b9-11eb-043e-7950b0d1ce4b
# ╟─41bfbfce-63b9-11eb-3315-f1ad0a828c67
# ╠═4aceb928-63b9-11eb-38a9-0f4ec57d95f6
# ╠═5a022d9e-63b9-11eb-0b0a-3dc16ed2b1ce
# ╠═734f54de-63b9-11eb-27c5-a135601ba3ad
# ╠═8be7b8c4-63b9-11eb-0e5d-effb5856e5ce
# ╟─9e4b1012-63b9-11eb-33bb-d766e60e61e2
# ╟─d19b6690-63b9-11eb-362b-550e7e0bb190
# ╟─dcd6f150-63b9-11eb-19a4-0304f869203a
# ╟─e6fa7cba-63b9-11eb-0770-6d2cdd08cf6d
# ╠═fb3a1a52-63b9-11eb-0bc6-e1fba2ada82f
# ╠═088dea6a-63ba-11eb-2aea-8bd4410071b3
# ╠═1584a62a-63ba-11eb-1ccf-1b8651770f75
# ╠═21b772fe-63ba-11eb-287a-b36c72b79084
# ╠═2f0f250a-63ba-11eb-187f-b1c93806addb
# ╠═50de6d94-63ba-11eb-0b43-ed16faff9dd8
# ╠═68064a0c-63ba-11eb-3bbf-17fa3851f382
# ╟─7659aca0-63ba-11eb-2efe-3d952047ee7d
# ╟─7faeaeb6-63ba-11eb-103c-cbb4fbf4f24b
# ╟─89a7418c-63ba-11eb-2e20-1fac8245672d
# ╠═99a30cb0-63ba-11eb-04b2-f9e62b4bfb98
# ╠═b179754a-63ba-11eb-3c7b-55e009489380
# ╟─bc086efa-63ba-11eb-065f-cd5ff0803f53
# ╟─c94842d2-63ba-11eb-1249-dd3341cdcd1a
# ╟─d193b4bc-63ba-11eb-2bc4-63ec49ef1d71
# ╠═23ae525c-63bb-11eb-31d1-cdc26c21546b
# ╟─63cfff56-63bc-11eb-322b-8329cb04fded
# ╟─7635a9d4-63bc-11eb-2b6a-2f2e1ffb6b6a
# ╠═b6547496-63bc-11eb-3f77-034e29bdd11d
# ╟─c13e21ae-63bc-11eb-0323-f58fa9e7783a
# ╟─cf752a42-63bc-11eb-0450-51a28f855353
# ╠═dcfd4b72-63bc-11eb-29ba-e5a7fa7ee50d
# ╟─e7a9393c-63bc-11eb-0da9-ad6ab03f30f3
# ╟─f9441f54-63bc-11eb-1273-affc5e83fde8
# ╟─05d1599e-63bd-11eb-1899-d387dfe903cf
# ╟─107934c0-63bd-11eb-309d-1f3c517deb3c
# ╟─1dc4a2ae-63bd-11eb-235c-1fd93d071330
# ╟─23a47848-63bd-11eb-0519-b9d191b54902
# ╟─2ea3cf80-63bd-11eb-10bf-910fd48c9ba0
# ╟─3985089e-63bd-11eb-38e8-a7dab8fa51d6
# ╠═44604774-63bd-11eb-0228-81c4346b1d16
# ╟─53069b3e-63bd-11eb-2b7f-5baf50ae000d
# ╠═5be87394-63bd-11eb-33ec-cda3cfcae091
# ╟─6c6f26ac-63bd-11eb-0350-57481a29969f
# ╟─6916c56a-63be-11eb-3fb4-fbf373f00a61
# ╠═7e4b52f0-63be-11eb-35b0-5b05e05e6136
# ╟─86ea35e0-63be-11eb-2fe2-3dcd50b8e279
# ╠═9d718ab6-63be-11eb-1e39-350dd83b1cf3
# ╟─a8b3c574-63be-11eb-27de-3515fec4c748
# ╠═b9b81dfc-63be-11eb-2982-29f73ad29cf2
# ╠═c5be9950-63be-11eb-0404-0f06dd409a46
# ╟─cdf71a48-63be-11eb-2c94-db3981fcfe15
# ╠═d64eb566-63be-11eb-36df-a16db49233ac
# ╠═e07ea2b2-63be-11eb-1a8f-55af47d59a88
# ╠═e8143922-63be-11eb-3a93-4bf933abe948
# ╟─ee11aece-63be-11eb-24d9-1d4b90a7a6b9
# ╠═fe101e5a-63be-11eb-20d7-7147d3d6afdb
# ╠═05c3c7dc-63bf-11eb-1620-a90dbedf4157
# ╟─0c46b7cc-63bf-11eb-061a-31586565022d
# ╠═1677f7e2-63bf-11eb-059f-83ea78ead39f
# ╟─226fbada-63bf-11eb-3cd0-5d07d6c8c1e8
# ╟─c1d18022-63bf-11eb-21a9-876544dd3553
# ╟─cd273b24-63bf-11eb-3126-1f37ce4cdc6e
# ╠═df2ce4de-63bf-11eb-1f00-c78758bb98e3
# ╟─ee638900-63bf-11eb-250a-53ed8a5523cd
# ╠═17a3d89c-63c0-11eb-2ae1-ebd583514f0e
# ╠═203bc4e2-63c0-11eb-33fb-9bc93e0fd74f
# ╠═285682fc-63c0-11eb-064e-2b34fafa81ce
# ╠═3e0eebb4-63c0-11eb-3168-edbe95b535cb
# ╠═4a7e4a16-63c0-11eb-169a-fbcb1fc5c874
# ╠═5215f69a-63c0-11eb-0947-bf7b827cb4cd
# ╠═5a8d0dae-63c0-11eb-2a3b-83519757fae9
# ╟─60fbe23a-63c0-11eb-0090-1b7c7c60af19
# ╟─6b3d3160-63c0-11eb-0ac0-8388c4d47603
# ╠═7875630c-63c0-11eb-241f-cb8e76e78df1
# ╠═8181233c-63c0-11eb-2828-87b66090b047
# ╠═896d9526-63c0-11eb-2f0e-f790d633ce92
# ╠═912a93a4-63c0-11eb-0e3b-bfc907b230cc
# ╟─985256f8-63c0-11eb-2856-b975188c3fa1
