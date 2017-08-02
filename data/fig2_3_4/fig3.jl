using JLD, PyPlot, Logging
@Logging.configure(level=INFO)

# Loading parameters
tau = .7

data = load("opa.jld")
ns = data["ns"]

figure(1,(7,5.5))
figure(2,(7,5.5))

for n in ns
# Computing alpha_tau for the chosen tau
	qmax = floor(Int64,n/4)
	ac = Array{Float64,1}()
	for q in 0:qmax
		data = load("./$n/opa_$n\_$q.jld")
			
		alphas = data["alphas_a"]
		
		params = linspace(0,1,100)
		i = 0
		p = 1
		while p > tau
			i += 1
			a = params[i]
			p = sum(alphas .> a)/length(alphas)
		end
			
		push!(ac,(params[i]+params[i-1])/2)
	end
# Plots 	
	figure(1)
	PyPlot.plot(0:qmax,ac,"-o",label="n = $n")

	figure(2)
	PyPlot.plot((0:qmax)/qmax,ac,"-o",label="n = $n")
end

figure(1)
xlabel("q")
ylabel("alpha_c")
legend()

figure(2)
xlabel("q/qmax")
ylabel("alpha_c")
legend()


