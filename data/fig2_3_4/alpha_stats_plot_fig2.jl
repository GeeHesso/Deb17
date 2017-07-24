include("/home/robin_delabays/LFNS/data/scripts/initialize.jl")

cols = ["b","g","r","c","m","k","y"]

data = load("opa.jld")
ns = data["ns"]

fignum = 69

for n in ns
	fignum += 1
	qmax = floor(Int64,n/4)
	
	for q in 0:qmax
		data = load("$n/opa_$n\_$q.jld")
		
		alphas = data["alphas_a"]
		
		as = linspace(0,pi,100)
		
		p = Array{Float64,1}()
		
		for a in linspace(0,1,100)
			push!(p,sum(alphas .> a)/100)
		end
		
		figure(fignum,(7,5.5))
		PyPlot.plot(as,p,"-o")
		
		if n == 83 && length(findin(q,[0,1,5,10,15,20])) > 0
			figure(69,(7,5.5))
			PyPlot.plot(as,p,"-o",label="q = $q")
		end
	end
	
	figure(fignum)
	title("n = $n")
end

figure(69)
PyPlot.plot([0,pi],[.7,.7],"--k")
title("n = 83")
xlabel("alpha")
ylabel("proportion")
legend()
axis([0,pi,-.1,1.1])


