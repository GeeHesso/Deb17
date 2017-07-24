include("/home/robin_delabays/LFNS/data/scripts/initialize.jl")

num = get_fignums()
if length(num) == 0
	fignum = 1
else
	fignum = maximum(num) + 1
end

cols = ["b","g","r","c","m"]

data1 = load("ofpa.jld")
n = data1["n"]
widths = data1["widths"]
fidxs = data1["fidxs"]
fidxs = [2,]

qmax = floor(Int64,n/4)
qs = collect(0:qmax)
tau = .7

a_t = zeros(Float64,length(widths)+1,qmax+1)
params = [0;collect(linspace(0,1,10000))]
files = readdir()

figure(88,(7,5.5))

for q in 0:qmax
	data = load("../fig2_3_4/opa_$n\_$q.jld")
	as = data["alphas_a"]
	i = 1
	p = 1
	while p > tau
		i += 1
		p = sum(as .> params[i])/length(as)
	end
	a_t[1,q+1] = (params[i]+params[i-1])/2
	
	l = 1
	
	for w in widths
		as = Array{Float64,1}()
		for j in fidxs
			if length(findin(files,["ofpa_$n\_$q\_$w\_$j.jld"])) > 0
				data = load("ofpa_$n\_$q\_$w\_$j.jld")
				as = [as;data["alphas_c"]]
			else
# If the file does not exist, it means that the fixed point was not found, i.e. we consider it has volume zeros		
				as = [as;zeros(1000)]
			end
		end
		i = 1
		p = 1
		while p > tau
			i += 1
			p = sum(as .> params[i])/length(as)
		end
		l += 1
		a_t[l,q+1] = (params[i]+params[i-1])/2
	end
end

ws = [0;widths]

for i in 1:5
	figure(88)
	PyPlot.plot(qs/qmax,vec(a_t[i,:]),"-o",label="beta = $(ws[i])")
end

PyPlot.plot(qs/qmax,((n-1)*(n-4*qs))/(2*(n-2)*n),"--k")

title("n = 83, tau = $tau")
legend()
xlabel("q/qmax")
ylabel("alpha_c")



