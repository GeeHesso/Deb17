include("/home/robin_delabays/LFNS/data/scripts/initialize.jl")

cols = ["b","g","r","c","m","k","y"]

data = load("opa.jld")
ns = data["ns"]

figure(1,(7,5.5))
figure(2,(7,5.5))

for n in ns
	qmax = floor(Int64,n/4)
	ac = Array{Float64,1}()
	for q in 0:qmax
		@info(" Dealing with (n,q) = ($n,$q)...")
		
		if n < 163 || (n == 163 && q > 27)
			data = load("/home/robin_delabays/LFNS/data/scripts/saved_alpha/201705121007/$n/opa_$n\_$q.jld")
			
			alphas = data["alphas_a"]
		
			params = linspace(0,1,100)
			i = 0
			p = 1
			while p > .7
				i += 1
				a = params[i]
				p = sum(alphas .> a)/1000
			end
			
			push!(ac,(params[i]+params[i-1])/2)
		else
			alphas = Array{Float64,1}()
			
@info("step 1")	
			for i in 1:1000
				data = load("/home/robin_delabays/LFNS/data/scripts/saved_alpha/201705121007/$n/opa_$n\_$q\_$i.jld")
				push!(alphas,data["alpha"])
			end
			
			params = linspace(0,1,100)
			i = 0
			p = 1
@info("step 2")	
			while p > .7
				i += 1
				a = params[i]
				p = sum(alphas .> a)/1000
			end
			
			push!(ac,(params[i]+params[i-1])/2)
		end
	end
	
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


