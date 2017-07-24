include("/home/robin_delabays/LFNS/data/scripts/initialize.jl")

cols = ["b","g","r","m"]

data = load("ofpa.jld")
qs = data["qs"]
fidxs = data["fidxs"]
widths = data["widths"]
n = data["n"]
nbins = data["nbins"]

qmax = floor(Int64,n/4)

data = load("ofpa_stats.jld")
quant_c = data["quant_c"]
mean_c = data["mean_c"]

qsup = maximum([q for (n,q,w) in keys(quant_c)])

for i in 1:4
	w = widths[i]
	num = get_fignums()
	if length(num) == 0
		fignum = 1
	else
		fignum = maximum(num) + 1
	end

	plot_q_c = Array{Float64,2}(5,0)
	qlist = Array{Int64,1}()
		
	for q in 0:qmax
		if length(findin(collect(keys(quant_c)),[(n,q,w)])) > 0
			push!(qlist,q)
			plot_q_c = [plot_q_c quant_c[(n,q,w)]]
		end
	end
		
	for j in 1:nbins+1
		figure(fignum,(10,8))
		PyPlot.plot(qlist,vec(plot_q_c[j,:]),"-o",color=cols[i],alpha = 0.1 + 0.9*(1-2*abs(j-nbins/2-1)/nbins))
	end

	PyPlot.plot(qlist,((n-1)*(n-4*qlist))/(2*(n-2)*n),"--",color=cols[i])
	
	figure(fignum)
	xlabel("q")
	ylabel("alpha threshold")
	title("Quantiles, n = $n, width = $w")
end
	




			
