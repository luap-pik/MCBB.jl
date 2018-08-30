# simple Kuramoto example
using HighBifLib
using DifferentialEquations
using Distributions
using LightGraphs
using Clustering

# common setup
N = 6
K = 0.5
nd = Normal(0.5, 0.05) # distribution for eigenfrequencies # mean = 0.5Hz, std = 0.5Hz
w_i_par = rand(nd,N)
net = erdos_renyi(N, 0.2)
A = adjacency_matrix(net)
ic = zeros(N)
ic_dist = Uniform(-pi,pi)
kdist = Uniform(0,10)
pars = kuramoto_network_parameters(K, w_i_par, N, A)
rp = ODEProblem(kuramoto_network, ic, (0.,100.), pars)

# range + range
ic_ranges = [0.:0.5:1.5 for i=1:N]
k_range = 1.:0.5:3.
(ic_coupling_problem, ic_par, N_mc) = setup_ic_par_mc_problem(rp, ic_ranges, pars, (:K, k_range))
ko_mcp = MonteCarloProblem(rp, prob_func=ic_coupling_problem, output_func=eval_ode_run)
tail_frac = 0.9 #
ko_emcp = EqMCProblem(ko_mcp, N_mc, tail_frac)
ko_sol = solve(ko_emcp)

# random + range
ic_ranges = ()->rand(ic_dist)
k_range = 1.:0.5:3.
N_ics = 20
(ic_coupling_problem, ic_par, N_mc) = setup_ic_par_mc_problem(rp, ic_ranges, N_ics, pars, (:K, k_range))
ko_mcp = MonteCarloProblem(rp, prob_func=ic_coupling_problem, output_func=eval_ode_run)
tail_frac = 0.9 #
ko_emcp = EqMCProblem(ko_mcp, N_mc, tail_frac)
ko_sol = solve(ko_emcp)


# random + random
ic_ranges = [()->rand(ic_dist)]
k_range = ()->rand(kdist)
N_ics = 20
(ic_coupling_problem, ic_par, N_mc) = setup_ic_par_mc_problem(rp, ic_ranges, N_ics, pars, (:K, k_range))
ko_mcp = MonteCarloProblem(rp, prob_func=ic_coupling_problem, output_func=eval_ode_run)
tail_frac = 0.9 #
ko_emcp = EqMCProblem(ko_mcp, N_mc, tail_frac)
ko_sol = solve(ko_emcp)

D = distance_matrix(ko_sol);

D = distance_matrix(ko_sol, ic_par[:,end]);
k = 4
fdist = k_dist(D,k);

# analysis
db_eps = 1
db_res = dbscan(full(D),db_eps,k)
cluster_meas = cluster_measures(ko_sol,db_res);
cluster_n = cluster_n_noise(db_res);
cluster_members = cluster_membership(ic_par[:,end],db_res,0.2,0.05);


true