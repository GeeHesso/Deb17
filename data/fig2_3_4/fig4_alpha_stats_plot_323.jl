# Generates figure 4

include("~/LFNS/data/scripts/initialize.jl")

@Logging.configure(level=INFO)

cols = ["b","g","r","c","m","k","y"]

ns = [23,43,83,163,323]
nbins = 4

data1 = load("opa_stats.jld")
data2 = load("opa_stats_163.jld")
data3 = load("opa_stats_323.jld")

quant_a = data1["quant_a"]
mean_a = data1["mean_a"]

for k in keys(data2["quant_a"])
	quant_a[(163,k)] = data2["quant_a"][k]
	mean_a[(163,k)] = data2["mean_a"][k]
end
for k in keys(data3["quant_a"])
	quant_a[(323,k)] = data3["quant_a"][k]
	mean_a[(323,k)] = data3["mean_a"][k]
end

plot_q_a = Dict{Int64,Array{Float64,2}}()

num = get_fignums()
if length(num) == 0
	fignum = 1
else
	fignum = maximum(num) + 1
end

i = 0

for n in ns 
	i += 1
	qmax = floor(Int,n/4)
	
	plot_q_a[n] = Array{Float64,2}(nbins+1,0)	
	plot_mean_a = Array{Float64,1}()
	
	for q in 0:qmax
		plot_q_a[n] = [plot_q_a[n] quant_a[(n,q)]]
		push!(plot_mean_a,mean_a[(n,q)])
	end
	
	for j in 1:nbins+1
		figure(fignum,(7,5.5))
		if j == floor(Int,nbins/2) + 1
			PyPlot.plot((0:qmax)/qmax,vec(plot_q_a[n][j,:]),"-o",color=cols[i],alpha = 0.1 + 0.9*(1-2*abs(j-nbins/2-1)/nbins),label="n=$n")
		else
			PyPlot.plot((0:qmax)/qmax,vec(plot_q_a[n][j,:]),"-o",color=cols[i],alpha = 0.1 + 0.9*(1-2*abs(j-nbins/2-1)/nbins),label="_nolegend_")
		end
		
		figure(fignum+2+i,(7,5.5))
		PyPlot.plot((0:qmax)/qmax,vec(plot_q_a[n][j,:]),"-o",color=cols[i],alpha = 0.1 + 0.9*(1-2*abs(j-nbins/2-1)/nbins))
	end
	
	title("Quantiles, n=$n")
	xlabel("q")
	ylabel("alpha threshold")
#	axis([0,80,0,1.2])
		
	figure(fignum+1,(7,5.5))
	PyPlot.plot((0:qmax)/qmax,plot_mean_a,"--s",color=cols[i])
	
	figure(fignum)
	PyPlot.plot((0:qmax)/qmax,((n-1)*(n-4*(0:qmax)))/(2*(n-2)*n),"--",color=cols[i])
	figure(fignum+2+i)
	PyPlot.plot((0:qmax)/qmax,((n-1)*(n-4*(0:qmax)))/(2*(n-2)*n),"--",color=cols[i])
	
end

	figure(fignum)
	xlabel("q")
	ylabel("alpha threshold")
	legend()
	title("Quantiles")
	
	figure(fignum+1)	
	xlabel("q")
	ylabel("alpha threshold")
	legend()
	title("Mean")

