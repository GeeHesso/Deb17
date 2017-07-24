include("/home/robin_delabays/LFNS/data/scripts/initialize.jl")

cols = ["b","g","r","c","m","k","y"]

data = load("opa.jld")
ns = data["ns"]
nbins = data["nbins"]

data = load("opa_stats.jld")
quant_w = data["quant_w"]
quant_a = data["quant_a"]
mean_w = data["mean_w"]
mean_a = data["mean_a"]

plot_q_w = Dict{Int64,Array{Float64,2}}()
plot_q_a = Dict{Int64,Array{Float64,2}}()

figure(3,(10,8))
figure(4,(10,8))

i = 0

for n in ns 
	i += 1
	qmax = floor(Int,n/4)
	
	plot_q_w[n] = Array{Float64,2}(nbins+1,0)	
	plot_q_a[n] = Array{Float64,2}(nbins+1,0)	
	plot_mean_a = Array{Float64,1}()
	
	for q in 0:qmax
		plot_q_w[n] = [plot_q_w[n] quant_w[(n,q)]]
		plot_q_a[n] = [plot_q_a[n] quant_a[(n,q)]]
		push!(plot_mean_a,mean_a[(n,q)])
	end
	
	for j in 1:nbins+1
		figure(3)
		if j == floor(Int,nbins/2) + 1
			PyPlot.plot((0:qmax),vec(plot_q_a[n][j,:]),"-o",color=cols[i],alpha = 0.1 + 0.9*(1-2*abs(j-nbins/2-1)/nbins),label="n=$n")
		else
			PyPlot.plot((0:qmax),vec(plot_q_a[n][j,:]),"-o",color=cols[i],alpha = 0.1 + 0.9*(1-2*abs(j-nbins/2-1)/nbins),label="_nolegend_")
		end
		
		figure(4)
		if j == floor(Int,nbins/2) + 1
			PyPlot.plot((0:qmax)/qmax,vec(plot_q_a[n][j,:]),"-o",color=cols[i],alpha = 0.1 + 0.9*(1-2*abs(j-nbins/2-1)/nbins),label="n=$n")
		else
			PyPlot.plot((0:qmax)/qmax,vec(plot_q_a[n][j,:]),"-o",color=cols[i],alpha = 0.1 + 0.9*(1-2*abs(j-nbins/2-1)/nbins),label="_nolegend_")
		end
		
#		figure(fignum+2+i)
#		PyPlot.plot((0:qmax),vec(plot_q_a[n][j,:]),"-o",color=cols[i],alpha = 0.1 + 0.9*(1-2*abs(j-nbins/2-1)/nbins))
	end
	
#	figure(fignum+1)
#	PyPlot.plot((0:qmax),plot_mean_a,"--s",color=cols[i])
	
#	figure(fignum+2)
#	PyPlot.plot((0:qmax),((n-1)*(n-4*(0:qmax)))/(2*(n-2)*n),"--",color=cols[i])
end

	figure(3)
	xlabel("q")
	ylabel("alpha threshold")
	legend()
	title("Quantiles")
	
	figure(4)
	xlabel("q/qmax")
	ylabel("alpha threshold")
	legend()
	title("Quantiles")

#=	figure(fignum+1)	
	xlabel("q")
	ylabel("alpha threshold")
	legend()
	title("Mean")
	
	figure(fignum+2)
	xlabel("q")
	ylabel("alpha threshold")
	legend()
	title("Theoretic")
=#


	
