### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ a6648952-5a6d-11eb-2c81-99d1514983c0
using Econometrics, RDatasets, GLM, GLMNet, Statistics, Plots, DataFrames, StatsPlots

# ╔═╡ 8f1873f2-63b0-11eb-289f-4d880cee7e5a
md"Импортируем нужные библиотеки"

# ╔═╡ b842ca4a-63b1-11eb-2190-0b6c834f85e0
md"### Первый взгляд на датасет"

# ╔═╡ 2f38687c-63b3-11eb-384e-c1847038f4c5
md"Для построения регрессионых моделей воспользуемся датасетом **Auto** из `RDatasets`"

# ╔═╡ 093d42ea-5a72-11eb-19b1-6b0abb122099
auto = dataset("ISLR", "Auto")

# ╔═╡ ad79eb3c-63b5-11eb-3d99-1f2b7aab9a18
md"Выведем некоторую статистическую информацию по колонкам"

# ╔═╡ 22840156-5a72-11eb-0e57-ff3178e5ee6f
describe(auto) 

# ╔═╡ c24ee52a-63d4-11eb-1815-0d184c506af2
md"**MPG** - это так называемые литры на 100 км. пути"

# ╔═╡ 61db537c-63d9-11eb-013c-9f74989da4d7
md"Сперва давайте посмотрим на графиках на зависимость между **MPG** и пятью первыми переменными
"

# ╔═╡ 6d6f598a-63da-11eb-0de2-fb70c755a0ef
scatter(auto.Cylinders, auto.MPG, xaxis="Cylinders", yaxis="MPG", legend = false)

# ╔═╡ fa02d9c0-63d9-11eb-1867-2f9780b312fe
scatter(auto.Displacement, auto.MPG, xaxis="Displacement", yaxis="MPG", legend = false)

# ╔═╡ 757e36ae-63d9-11eb-277a-9b2ac8f3b483
scatter(auto.Horsepower, auto.MPG, xaxis="Horsepower", yaxis="MPG", legend = false)

# ╔═╡ d46d4030-63d9-11eb-32d0-1780207fae50
scatter(auto.Weight, auto.MPG, xaxis="Weight", yaxis="MPG", legend = false)

# ╔═╡ e2e70718-63d9-11eb-02e5-0dff07a9c6c7
scatter(auto.Acceleration, auto.MPG, xaxis="Acceleration", yaxis="MPG", legend = false)

# ╔═╡ b26f1aac-63da-11eb-2e66-27cd5597e043
md"
Важно также посмотреть на *outliers* - так называемые выбросы. Подробности и тонкости работы с данными представлены в другом туториале, тут же мы посмотрим только на один важный момент :)

Можно построить **box plot** и после удалить выбросы, которые видны на графике
"

# ╔═╡ d987355c-63da-11eb-1170-910084cc4274
boxplot(auto.Horsepower, title = "Box Plot - Horsepower", ylabel = "Horsepower", legend = false)

# ╔═╡ f0845d38-63db-11eb-0be2-eb5217bf6170
md"### Модели в `GLM`"

# ╔═╡ 17e60466-63c4-11eb-1f97-072f5539cb38
md"Для начала воспользуемся пакетом `GLM`. Начнем с простой парной регрессии: $$\widehat{MPG} = \widehat{\beta_0} + \widehat{\beta_1} \cdot Horsepower$$"

# ╔═╡ 8b294048-63bd-11eb-3df5-959b55069357
linear_model = lm(@formula(MPG ~ Horsepower), auto)

# ╔═╡ e86909f8-63c4-11eb-3f85-9dd2450e8c5f
md"Выведем коэффициент детерминации $$R^2$$"

# ╔═╡ 1fc60af8-63c1-11eb-0814-054e7b9be6f3
GLM.r2(linear_model)

# ╔═╡ f42c722a-63c4-11eb-262c-514bf90aa295
md"Horsepower объясняет примерно 60,6% дисперсии разброса MPG. Вполне неплохо, построим график с данными, регрессией и доверительным интервалом для предсказания с уровнем доверия 95%"

# ╔═╡ 4161b2ca-63c1-11eb-1f47-3f66d74863c3
begin 
	pred = DataFrame(Horsepower = 45:0.1:230);
	pr = GLM.predict(linear_model, pred, interval = :prediction, level = 0.95);
	plot(xlabel="Horsepower", ylabel="MPG", legend=:best)
	plot!(auto.Horsepower, auto.MPG, label="data", seriestype=:scatter)
	plot!(pred.Horsepower, pr.prediction, label="model", linewidth=3, 
        ribbon = (pr.prediction .- pr.lower, pr.upper .- pr.prediction))
end

# ╔═╡ 35163060-63c7-11eb-2013-d1878e8e2c0b
md"По графику видим, что связь возможно гиперболическая. Рассмотрим модель $$\widehat{MPG} = \widehat{\beta_0} + \widehat{\beta_1} \cdot \dfrac{1}{Horsepower}$$"

# ╔═╡ 65664ad0-63c6-11eb-3e2f-7bf9841d5265
hyperbolic_model = lm(@formula(MPG ~ 1 / Horsepower), auto)

# ╔═╡ 7582b77a-63c6-11eb-3ac2-615c4e294aab
GLM.r2(hyperbolic_model)

# ╔═╡ 5ba889e6-63c7-11eb-14a1-216dee432abe
md"Эта модель, похоже, и правда лучше объясняет **MPG**. Построим аналогичный график"

# ╔═╡ 8bb5ec74-63c6-11eb-1c3e-d358b4ebc5c5
begin 
	predd = DataFrame(Horsepower = 45:0.1:230);
	prd = GLM.predict(hyperbolic_model, pred, interval = :prediction, level = 0.95);
	plot(xlabel="Horsepower", ylabel="MPG", legend=:best)
	plot!(auto.Horsepower, auto.MPG, label="data", seriestype=:scatter)
	plot!(predd.Horsepower, prd.prediction, label="model", linewidth=3, 
        ribbon = (prd.prediction .- prd.lower, prd.upper .- prd.prediction))
end

# ╔═╡ 01019b9e-63dc-11eb-3148-9b08890b53c9
md"Теперь перейдем к множественной регрессии. 

Мы видим, что есть линейная связь между **MPG** и **Horsepower** и **MPG** и **Weight**"

# ╔═╡ 0b27def8-63dc-11eb-003c-454b21b38132
reg = lm(@formula(MPG ~ Weight + Horsepower), auto)

# ╔═╡ 38766bac-63dc-11eb-2dbc-978b5fb3a637
md"
Видим достаточно знакомую и родную табличку! Но фанаты **R** и **Stata** могут справедливо заметить, что как-то маловато всего представлено в таблице. Например, не видно коэффициента детерминации. Не унывать! **Julia** - за минимализм. Да и вывести всё, что Вас интересует, невероятно просто. Достаточно лишь указать интересующий метод и применить его к нашей модели.
"

# ╔═╡ 550be2bc-63dc-11eb-331b-d71a3071ec66
R2 = GLM.r2(reg) 

# ╔═╡ 6cd53b1e-63dc-11eb-074a-41c43b6dfaaf
coefs = GLM.coef(reg)

# ╔═╡ 7df28c9e-63dc-11eb-3c8e-5732e36a7e5c
md"
Что ещё можно посмотреть, применив метод к модели?

*dof_residual*: степени свободы остатков (если имеет смысл)

*stderror*: стандартные ошибки коэффициентов

*vcov*: ковариационная матрица оценок коэффициентов

И много всего другого! Интересующиеся могут обратиться к документации `GLM`."

# ╔═╡ ce4f3232-63dc-11eb-374d-412a97f8d2c8
md"
А теперь давайте предсказать значение, задав заранее значения **Horsepower** и **Weight**.
"

# ╔═╡ de284b94-63dc-11eb-2d26-1391517ed17d
new_data = DataFrame(Horsepower = [200, 250], Weight = [4000, 3800])

# ╔═╡ 09221186-63dd-11eb-3c1a-a7fa2ef46e3e
prediction_GLM = DataFrame(MPG_pred = GLM.predict(reg, new_data))

# ╔═╡ 3a4f1000-63e3-11eb-3f33-d1590d15b611
md"
Можем также посмотреть на имеющиеся наблюдения и сравнить с предсказанными значениями
"

# ╔═╡ 88873fa4-63e3-11eb-2d3a-e9d30a385d93
md"Посмотрим на распределение ошибок"

# ╔═╡ 76daf6ba-63e3-11eb-3e19-ff67bdb86a0e
begin
	performance = DataFrame(y_actual = auto.MPG, y_predicted = GLM.predict(reg));
	error = performance[:y_actual] - performance[:y_predicted];
	histogram(error, bins = 50, title = "Error Analysis", ylabel = "Frequency", 		xlabel = "Error",legend = false)
end

# ╔═╡ 92918540-63e3-11eb-1b57-3d49dfa75b09
md"Ошибки распределены нормально, судя по гистограмме"

# ╔═╡ 4b1d9a88-63dd-11eb-3190-21c2a57ed0b0
md"### Модели в `Econometrics`"

# ╔═╡ c080265a-63e3-11eb-1aad-8f85c3d18f3e
md"
Также рассмотрим пакет `Econometrics`, который позволяет строить линейные регрессии, но немного отличается от `GLM`. Конечно, основные различия можно увидеть при более глубоком анализе, нежели тот, что мы приводим в нашем туториале, поэтому заинтересовавшиеся могут обратиться к документации пакета.
"

# ╔═╡ e66b840e-63e3-11eb-12f7-8d4155f58990
model = fit(EconometricModel, @formula(MPG ~ Weight + Horsepower), auto)

# ╔═╡ 6c1f9266-63e4-11eb-08bf-cbabc486dd30
md"
Фанаты **R** и **Stata** могут ликовать! Теперь мы видимт табличку, в которой есть и коэффициент детерминации, и LR-тест, и много всего интересного для благородных Донов!
"

# ╔═╡ 0255de96-63e4-11eb-3336-fb9a753ae588
md"Сравним с аналогичной моделью из `GLM`"

# ╔═╡ 13df2904-63e4-11eb-0600-d1c1ebfe9d84
reg 

# ╔═╡ 2d6038be-63e4-11eb-2320-d7251a567785
md"Как мы видим, все статистические характеристики коэффициентов идентичны, только в `Econometrics` выводится еще разная полезная информация"

# ╔═╡ d8a330c2-63db-11eb-2ad9-6b6a7126d393
md"### F-тест на сравнение моделей"

# ╔═╡ d3efe6bc-63b1-11eb-2ad2-f1df05dd812d
md"Рассмотрим две модели: 

$$\widehat{MPG}_1 = \widehat{\beta_0} + \widehat{\beta_1} \cdot Weight + \widehat{\beta_2} \cdot Cylinders$$

$$\widehat{MPG}_2 = \widehat{\gamma_0} + \widehat{\gamma_1} \cdot Weight + \widehat{\gamma_2} \cdot Cylinders + \widehat{\gamma_3} \cdot Horsepower$$

F-тест позволит нам сравнить данные модели, и решить, является ли коэффициент $$\gamma_3$$ статистически значимым. Для большей ясности запишем гипотезы:

$$H_0: \gamma_3 = 0$$

$$H_1: \gamma_3 \neq 0$$

С помощью библиотеки `GLM` проведем F-тест
"

# ╔═╡ 1b8b1ad2-63b2-11eb-0d2e-75df725c1846
unrestricted_model = lm(@formula(MPG ~ Weight + Cylinders + Horsepower), auto)

# ╔═╡ 4617f266-63b2-11eb-257f-63906ea45f97
restricted_model = lm(@formula(MPG ~ Weight + Cylinders), auto)

# ╔═╡ 5a5e4770-63b2-11eb-3228-5dc5ea457b7b
GLM.ftest(unrestricted_model.model, restricted_model.model)

# ╔═╡ ee475c76-63b5-11eb-01ea-4121230e1b6f
md"Как мы видим, p-value, или p(>F), равен 0.0003, то есть он меньше любого разумного уровня значимости, отсюда $$\gamma_3 \neq 0$$ при любом разумном уровне значимости"

# ╔═╡ d65fc5c2-6215-11eb-3f82-2de3ce633b93
md"### Регуляризация"

# ╔═╡ b7f68a00-63b7-11eb-2789-1dce3762f0a6
md"Так же в **Julia** можно построить модели линейной регрессии с L1-регуляризацией (то есть **LASSO**) и L2-регуляризацией (то есть **Ridge**). Для этого воспользуемся библиотекой `GLMNet`. Заодно введем квадраты пяти переменных, поэлементно возводя их в квадрат (просто потому что)"

# ╔═╡ 17994b30-6216-11eb-05de-d1e8fef75c42
begin
	auto["Cylinders_sq"] = auto["Cylinders"].^2;
	auto["Displacement_sq"] = auto["Displacement"].^2;
	auto["Horsepower_sq"] = auto["Horsepower"].^2;
	auto["Weight_sq"] = auto["Weight"].^2;
	auto["Acceleration_sq"] = auto["Acceleration"].^2;
end

# ╔═╡ 9ebe9d56-63b8-11eb-204f-fb4007c3392c
md"Важное уточнение: `GLMNet` работает не с датафреймами, а с массивами, поэтому выделим нужные признаки и передевем их в массивы"

# ╔═╡ b77d7afc-61e1-11eb-0e0f-55c1b299680c
X = hcat(Array(auto[:, 3:7]), Array(auto[:, 11:14]))

# ╔═╡ c2e747e2-61e1-11eb-3ac5-d7bc26e4b98e
y = Array(auto[:, 1])

# ╔═╡ e42b986c-63b8-11eb-32c7-45cbb84738bc
md"Сначала инициализируем модель **LASSO**, потом **Ridge**. 

Подбираем оптимальные $$\lambda$$ с помощью кросс-валидации"

# ╔═╡ c6253aa6-61e4-11eb-214c-412220911078
lasso = glmnetcv(X, y, alpha = 1)

# ╔═╡ 17f4ee00-62d8-11eb-03f6-e78344c2183b
ridge = glmnetcv(X, y, alpha = 0)

# ╔═╡ fdd471ee-63b8-11eb-1231-f707db1c55d8
md"Хочется сравнить эти модели, напишем простую функцию для рассчета коэффциента детерминации. Тут нам нужна функция mean() из пакета `Statistics`"

# ╔═╡ d35f5116-61ee-11eb-1d2d-a70a56e4f5c4
function r2(model, X, y)
	RSS = sum((GLMNet.predict(model, X) - y).^2);
	TSS = sum((y .- Statistics.mean(y)).^2);
	(TSS - RSS)/TSS;
end

# ╔═╡ fdb7edfa-6212-11eb-07e4-19667961840b
r2(lasso, X, y)

# ╔═╡ 1fe3177c-62d8-11eb-0193-cb9420f3f4c7
r2(ridge, X, y)

# ╔═╡ 1f5c2190-63b9-11eb-302e-75f90c39c114
md"Тут модель **LASSO** показала себя лучше"

# ╔═╡ Cell order:
# ╟─8f1873f2-63b0-11eb-289f-4d880cee7e5a
# ╠═a6648952-5a6d-11eb-2c81-99d1514983c0
# ╟─b842ca4a-63b1-11eb-2190-0b6c834f85e0
# ╟─2f38687c-63b3-11eb-384e-c1847038f4c5
# ╠═093d42ea-5a72-11eb-19b1-6b0abb122099
# ╟─ad79eb3c-63b5-11eb-3d99-1f2b7aab9a18
# ╠═22840156-5a72-11eb-0e57-ff3178e5ee6f
# ╟─c24ee52a-63d4-11eb-1815-0d184c506af2
# ╟─61db537c-63d9-11eb-013c-9f74989da4d7
# ╠═6d6f598a-63da-11eb-0de2-fb70c755a0ef
# ╠═fa02d9c0-63d9-11eb-1867-2f9780b312fe
# ╠═757e36ae-63d9-11eb-277a-9b2ac8f3b483
# ╠═d46d4030-63d9-11eb-32d0-1780207fae50
# ╠═e2e70718-63d9-11eb-02e5-0dff07a9c6c7
# ╟─b26f1aac-63da-11eb-2e66-27cd5597e043
# ╠═d987355c-63da-11eb-1170-910084cc4274
# ╟─f0845d38-63db-11eb-0be2-eb5217bf6170
# ╟─17e60466-63c4-11eb-1f97-072f5539cb38
# ╠═8b294048-63bd-11eb-3df5-959b55069357
# ╟─e86909f8-63c4-11eb-3f85-9dd2450e8c5f
# ╠═1fc60af8-63c1-11eb-0814-054e7b9be6f3
# ╟─f42c722a-63c4-11eb-262c-514bf90aa295
# ╠═4161b2ca-63c1-11eb-1f47-3f66d74863c3
# ╟─35163060-63c7-11eb-2013-d1878e8e2c0b
# ╠═65664ad0-63c6-11eb-3e2f-7bf9841d5265
# ╠═7582b77a-63c6-11eb-3ac2-615c4e294aab
# ╟─5ba889e6-63c7-11eb-14a1-216dee432abe
# ╠═8bb5ec74-63c6-11eb-1c3e-d358b4ebc5c5
# ╟─01019b9e-63dc-11eb-3148-9b08890b53c9
# ╠═0b27def8-63dc-11eb-003c-454b21b38132
# ╟─38766bac-63dc-11eb-2dbc-978b5fb3a637
# ╠═550be2bc-63dc-11eb-331b-d71a3071ec66
# ╠═6cd53b1e-63dc-11eb-074a-41c43b6dfaaf
# ╟─7df28c9e-63dc-11eb-3c8e-5732e36a7e5c
# ╟─ce4f3232-63dc-11eb-374d-412a97f8d2c8
# ╠═de284b94-63dc-11eb-2d26-1391517ed17d
# ╠═09221186-63dd-11eb-3c1a-a7fa2ef46e3e
# ╟─3a4f1000-63e3-11eb-3f33-d1590d15b611
# ╟─88873fa4-63e3-11eb-2d3a-e9d30a385d93
# ╠═76daf6ba-63e3-11eb-3e19-ff67bdb86a0e
# ╟─92918540-63e3-11eb-1b57-3d49dfa75b09
# ╟─4b1d9a88-63dd-11eb-3190-21c2a57ed0b0
# ╟─c080265a-63e3-11eb-1aad-8f85c3d18f3e
# ╠═e66b840e-63e3-11eb-12f7-8d4155f58990
# ╟─6c1f9266-63e4-11eb-08bf-cbabc486dd30
# ╟─0255de96-63e4-11eb-3336-fb9a753ae588
# ╠═13df2904-63e4-11eb-0600-d1c1ebfe9d84
# ╟─2d6038be-63e4-11eb-2320-d7251a567785
# ╟─d8a330c2-63db-11eb-2ad9-6b6a7126d393
# ╟─d3efe6bc-63b1-11eb-2ad2-f1df05dd812d
# ╠═1b8b1ad2-63b2-11eb-0d2e-75df725c1846
# ╠═4617f266-63b2-11eb-257f-63906ea45f97
# ╠═5a5e4770-63b2-11eb-3228-5dc5ea457b7b
# ╟─ee475c76-63b5-11eb-01ea-4121230e1b6f
# ╟─d65fc5c2-6215-11eb-3f82-2de3ce633b93
# ╟─b7f68a00-63b7-11eb-2789-1dce3762f0a6
# ╠═17994b30-6216-11eb-05de-d1e8fef75c42
# ╟─9ebe9d56-63b8-11eb-204f-fb4007c3392c
# ╠═b77d7afc-61e1-11eb-0e0f-55c1b299680c
# ╠═c2e747e2-61e1-11eb-3ac5-d7bc26e4b98e
# ╟─e42b986c-63b8-11eb-32c7-45cbb84738bc
# ╠═c6253aa6-61e4-11eb-214c-412220911078
# ╠═17f4ee00-62d8-11eb-03f6-e78344c2183b
# ╟─fdd471ee-63b8-11eb-1231-f707db1c55d8
# ╠═d35f5116-61ee-11eb-1d2d-a70a56e4f5c4
# ╠═fdb7edfa-6212-11eb-07e4-19667961840b
# ╠═1fe3177c-62d8-11eb-0193-cb9420f3f4c7
# ╟─1f5c2190-63b9-11eb-302e-75f90c39c114
