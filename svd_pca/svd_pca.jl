### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ b2acf9f8-63e4-11eb-1135-97ce72d2dce0
begin	
	import Pkg
	Pkg.activate(".")
	Pkg.instantiate()
	using LinearAlgebra
	using Images
	using MultivariateStats
end

# ╔═╡ f0be2420-63e6-11eb-3c3f-7d876a6b1d07
md"""
Instantiate necessary dependencies
"""

# ╔═╡ 76551244-63c7-11eb-18fb-ede832cd86d7
md"""
## Часть первая, PCA

Пусть у нас есть $X_{n \times k}$ – матрица объектов-признаков (перед началом использования алгоритма признаки необходимо центрировать и нормировать), и нам интересно понизить размерность с $n$ до $d$. То есть мы хотим спроецировать наши признаки на линейную оболочку $Lin(u_1, u_2, \ldots, u_d),$  где вектора $u_1, u_2, \ldots, u_d$ отвечают следующим условиям:

$\langle u_i, u_j \rangle= 0$

$||u_i||^2 = 1$

При проецировании выборки на вектора $u_1, u_2, \ldots, u_d$ получается максимальная дисперсия среди всех возможных способов выбрать $d$ компонент


Запишем теперь проекцию $XU_d$ выборки $X$ на $U_d,$ где $U_d = (u_1, u_2, \ldots, u_d)$
"""

# ╔═╡ 67bd6e22-63ce-11eb-3a69-eb83e1a34d8e
md"""
Наша задача максимизировать дисперсию проекции, более того нам известно, что 
$Var(XU_d) = tr(U_d^{T}X^{T}XU_{d}) = \sum_{i=1}^{d} ||Xu_i||^2$

Теперь поставим задачу для первой компоненты:

$||Xu_1||^2 \longrightarrow max$
$||u_1||^2 \leq 1$

Запишем Лагранжиан 

$\Lambda = ||Xu_1||^2 - \lambda(||u_1||^2 - 1) \longrightarrow max$

Тогда

$\dfrac{\partial\Lambda}{\partial u_1} = 2X^{T}Xu_1 - 2 \lambda u_1 = 0$


Отсюда получаем, что $X^{T}Xu_1 = \lambda u_1, $ следовательно, $u_1$ – случайный вектор матрицы $X^TX$.
"""

# ╔═╡ 3b99d15e-63d0-11eb-1747-21bd1745dbed
md"""
Тогда можно переформулировать исходную задачу следующим образом:

$||Xu_1||^2  = u_1^{T}X^{T}Xu_1 = u_{1}\lambda u_1 = \lambda ||u_1||^2 = \lambda \longrightarrow max$
 
Таким образом, для определения главных компонент нам необходимо выбрать $d$ собственных векторов, соответствующих самым крупным обственным значениям.
"""

# ╔═╡ c015144a-63d0-11eb-2d0a-375237a15729
md"""
Пример использования PCA в Julia (нерабочий)
"""

# ╔═╡ 5fde095e-63d2-11eb-23bc-41bea2533adf
begin

	# train a PCA model
	M = fit(PCA, X_train; maxoutdim=100)

	# apply PCA model to testing set
	Y_test = transform(M, X_test)

	# reconstruct testing observations (approximately)
	X_rseconstruct = reconstruct(M, Y_test)
end

# ╔═╡ fd0c0110-63d5-11eb-3d15-affbf1bfb4be
md"""
## Часть вторая, SVD

SVD находит свое применение в разных областях прикладной математики. Наиболее наглядные из них: сжатие изображений и использование в PCA. 

TODO:
* Сжатие изображений (часть done, нужно еще добавить показатель компрессии и сколько, мы сохраняем памяти в битах)
* Объяснение SVD
* Связь с PCA

"""

# ╔═╡ 4012c11e-63d7-11eb-1bd5-db4b5b697340
begin
	path = pwd() * "/assets/nighthawks.jpg"
	nighthawks = load(path)
end

# ╔═╡ fff90302-63d8-11eb-18b1-1faf5c7a1295
nhawks_tensor = permutedims(channelview(nighthawks), (2,3,1));

# ╔═╡ 32d9ab44-63e5-11eb-1f62-1974acba8dbd
size(nhawks_tensor)

# ╔═╡ 61edcf88-63da-11eb-1d4c-e703a501ef96
# Taken from https://juliaimages.org/latest/democards/examples/color_channels/color_separations_svd/

function rank_approx(F::SVD, k)
    U, S, V = F
    M = U[:, 1:k] * Diagonal(S[1:k]) * V[:, 1:k]'
    clamp01!(M) # clamps values onto [0,1]
end

# ╔═╡ 37bd6d68-63df-11eb-2799-490a91188fa9
function ImageCompression(channels, thresholds::AbstractArray)
	"""
		Wrapped around code presented here:				  			https://juliaimages.org/latest/democards/examples/color_channels/color_separations_svd/
	
	channels : ChannelView of an image, i.e. channelview(img)
	Make sure that channels dimension is last:
		size(img) = (m, n, c), where c is the number of channels
		or the function will throw DomainError
	thresholds: an array containg various numbers of singular values to keep
	"""
	if size(channels)[3] != 3
		throw(DomainError(size(channels)[3], "Channels dim should be 3"))
	end
	svdfactors = svd.(eachslice(channels; dims=3))
	imgs = map(thresholds) do k
		colorview(RGB, rank_approx.(svdfactors, k)...)
	end
	return imgs
end

# ╔═╡ 87c5328e-63e2-11eb-281e-f1d33b8a4d62
begin
	thresholds = [1, 5, 10, 25, 50, 100]
	mosaicview(nighthawks, ImageCompression(channelview(nhawks_tensor), thresholds)...; nrow=size(thresholds)[1] + 1, npad=15)
end

# ╔═╡ Cell order:
# ╠═f0be2420-63e6-11eb-3c3f-7d876a6b1d07
# ╠═b2acf9f8-63e4-11eb-1135-97ce72d2dce0
# ╠═76551244-63c7-11eb-18fb-ede832cd86d7
# ╠═67bd6e22-63ce-11eb-3a69-eb83e1a34d8e
# ╠═3b99d15e-63d0-11eb-1747-21bd1745dbed
# ╠═c015144a-63d0-11eb-2d0a-375237a15729
# ╠═5fde095e-63d2-11eb-23bc-41bea2533adf
# ╠═fd0c0110-63d5-11eb-3d15-affbf1bfb4be
# ╠═4012c11e-63d7-11eb-1bd5-db4b5b697340
# ╠═fff90302-63d8-11eb-18b1-1faf5c7a1295
# ╠═32d9ab44-63e5-11eb-1f62-1974acba8dbd
# ╠═61edcf88-63da-11eb-1d4c-e703a501ef96
# ╠═37bd6d68-63df-11eb-2799-490a91188fa9
# ╠═87c5328e-63e2-11eb-281e-f1d33b8a4d62
