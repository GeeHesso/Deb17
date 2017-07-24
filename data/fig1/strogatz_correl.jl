# Compute the correlation coefficient between initial and final winding number for a Kuramoto cycle of length n.

# Load simulators
include("~/LFNS/data/scripts/initialize.jl")
include("~/LFNS/data/scripts/get_rgb.jl")

# Load data
d1 = load("os_83_15.jld")
d2 = load("os_83_44.jld")
d3 = load("os_83_368.jld")
d4 = load("os_83_463.jld")
d5 = load("os_83_630.jld")

q_i = [d1["q_i"];d2["q_i"];d3["q_i"];d4["q_i"];d5["q_i"]]
q_f = [d1["q_f"];d2["q_f"];d3["q_f"];d4["q_f"];d5["q_f"]]

n = d1["n"]
n_iter = length(q_i)

# Compute correlation (given by r_if)
qmax = floor(Int64,n/4)
qs = collect(-qmax:qmax)

prop_i_f = zeros(Float64,2*qmax+1,2*qmax+1)
test = zeros(Bool,2*qmax+1,2*qmax+1)

for i in 1:n_iter
	prop_i_f[q_i[i]+qmax+1,q_f[i]+qmax+1] += 1/n_iter
	test[q_i[i]+qmax+1,q_f[i]+qmax+1] = true
end

m_i = mean(q_i)
m_f = mean(q_f)
s_i = sqrt(mean((q_i-m_i).^2))
s_f = sqrt(mean((q_f-m_f).^2))
cov_if = mean((q_i-m_i).*(q_f-m_f))
r_if = cov_if/(s_i*s_f)

a = cov_if/(s_i)^2
b = m_f - a*m_i

# Plot
figure(99,(10,8))

for i in -qmax:qmax
	for j in -qmax:qmax
		if test[i+qmax+1,j+qmax+1]
			PyPlot.plot(i,j,color=get_rgb(prop_i_f[i+qmax+1,j+qmax+1],0.,maximum(prop_i_f)),"o")
		end
	end
end

x = linspace(-qmax,qmax,1000)
PyPlot.plot(x,a*x+b,"--k",label="lin.reg.: y = $(round(a,2))x + $(round(b,2))")

xlabel("q_i")
ylabel("q_f")
legend(loc=2)
axis([minimum(q_i)-1,maximum(q_i)+1,minimum(q_f)-1,maximum(q_f)+1])
title("c.c. = $(round(r_if,2))")


