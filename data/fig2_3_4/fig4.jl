using JLD, PyPlot, Logging
@Logging.configure(level=INFO)

# Loading parameters
cols = ["b","g","r","c","m"]

data = load("opa.jld")
ns = data["ns"]
nbins = data["nbins"]
n_q = data["n_q"]

quant_a = Dict{Tuple{Int64,Int64},Array{Float64,1}}()
mean_a = Dict{Tuple{Int64,Int64},Float64}()

# Computing the quantiles for each n and q
for (n,q) in n_q
	data = load("./$n/opa_$n\_$q.jld")
	alphas = collect(data["alphas_a"])
	
	mean_a[(n,q)] = mean(alphas)
	quant_a[(n,q)] = quantile(alphas,linspace(0,1,nbins+1))
end

# Plots
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

