include("../../initialize.jl")

data = load("ofpa.jld")
files = readdir()

n = data["n"]
nbins = data["nbins"]
qs = data["qs"]
widths = data["widths"]
fidxs = data["fidxs"]

quant_c = Dict{Tuple{Int64,Int64,Float64},Array{Float64,1}}()
mean_c = Dict{Tuple{Int64,Int64,Float64},Float64}()

for q in qs
	for width in widths
		alphas_c = Array{Float64,1}()
		for idx in fidxs
			if length(findin(files,["ofpa_$n\_$q\_$width\_$idx.jld"])) > 0
				data = load("ofpa_$n\_$q\_$width\_$idx.jld")
				alphas_c = [alphas_c;data["alphas_c"]]
			end
		end
		if length(alphas_c) > 0
			mean_c[(n,q,width)] = mean(alphas_c)
			quant_c[(n,q,width)] = quantile(alphas_c,linspace(0,1,nbins+1))
		end
	end
end
	

save("ofpa_stats.jld","quant_c",quant_c,"mean_c",mean_c)
