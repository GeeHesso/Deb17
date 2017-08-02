# Plots the distribution of winding numbers of random initial conditions and the corresponding final state for a Kuramoto cycle of length n, together with a least squares zero-mean gaussian fit. 

using JLD, PyPlot

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

qmax = floor(Int64,n/4)
qs = collect(-qmax:qmax)

# Generate histogram
prob_i = zeros(Float64,2*qmax+1)
prob_f = zeros(Float64,2*qmax+1)

for q in q_i
	prob_i[q+qmax+1] += 1/n_iter
end

for q in q_f
	prob_f[q+qmax+1] += 1/n_iter
end



function dD(s::Float64,x::Array{Int64,1},y::Array{Float64,1})
	return sum((1/(s*sqrt(2*pi))*exp(-x.^2/(2*s^2))-y).^2)
end


# Best standard deviation for initial winding number distribution
sm = 1e-6
sp = 1e3
ss = linspace(sm,sp,11)
d = abs(ss[2]-ss[1])
eps = 1e-10

while d > eps
	slope = -1
	i = 1
	while slope < 0 && i < 11
		i += 1
		slope = sign(dD(ss[i],qs,prob_i) - dD(ss[i-1],qs,prob_i))
	end
	
	if i <= 2
		sp = ss[2]
	elseif i >= 11
		sm = ss[10]
	else
		sm = ss[i-2]
		sp = ss[i]
	end
	
	ss = linspace(sm,sp,11)
	d = abs(ss[2]-ss[1])
end

s_i = ss[6]

# Best standard deviation for final winding number distribution
sm = 1e-6
sp = 1e3
ss = linspace(sm,sp,11)
d = abs(ss[2]-ss[1])
eps = 1e-10

while d > eps
	slope = -1
	i = 1
	while slope < 0 && i < 11
		i += 1
		slope = sign(dD(ss[i],qs,prob_f) - dD(ss[i-1],qs,prob_f))
	end
	
	if i <= 2
		sp = ss[2]
	elseif i >= 11
		sm = ss[10]
	else
		sm = ss[i-2]
		sp = ss[i]
	end
	
	ss = linspace(sm,sp,11)
	d = abs(ss[2]-ss[1])
end

s_f = ss[6]


# Plots

figure(11,(7,5.5))

PyPlot.plot(qs,prob_i,"ob",label = "initial winding (s = $(round(s_i,2)))")
PyPlot.plot(qs,prob_f,"or",label = "final winding (s = $(round(s_f,2)))")

x = linspace(-qmax,qmax,1000)
y_i = 1/(s_i*sqrt(2*pi))*exp(-x.^2/(2*s_i^2))
y_f = 1/(s_f*sqrt(2*pi))*exp(-x.^2/(2*s_f^2))
PyPlot.plot(x,y_i,"-b",linewidth=2,x,y_f,"-r")

xx = Array{Float64,1}()
yy_i = Array{Float64,1}()
yy_f = Array{Float64,1}()

for i in 1:(2*qmax+1)
	push!(xx,qs[i]-.5)
	push!(xx,qs[i]+.5)
	push!(yy_i,prob_i[i])
	push!(yy_i,prob_i[i])
	push!(yy_f,prob_f[i])
	push!(yy_f,prob_f[i])
end
PyPlot.plot(xx,yy_i,":b",linewidth=2,xx,yy_f,":r")


xlabel("Winding number")
ylabel("Probability")
#legend()
axis([-12,12,0,.25])




