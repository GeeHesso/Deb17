######## DATA ARE IN /home/robin_delabays/LFNS/data/scripts/saved_alpha/20170512... ##################


include("/home/robin_delabays/LFNS/data/scripts/initialize.jl")

cols = ["b","g","r","c","m","k","y"]

fignum = 69

for q in [0,5,10,15,20]
	data = load("83/opa_83_$q.jld")
	
	alphas = data["alphas_a"]
	
	as = linspace(0,1,100)
	
	p = Array{Float64,1}()
	
	for a in as
		push!(p,sum(alphas .> a)/1000)
	end
	
	figure(fignum,(7,5.5))
	PyPlot.plot(as,p,"-o",label="q = $q")
end

PyPlot.plot([0,1],[.7,.7],"--k")
title("n = 83")
xlabel("alpha")
ylabel("proportion")
legend()
axis([0,1,-.1,1.1])


