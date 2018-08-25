module HighBifLib

# Contains example systems
include("systems.jl")

# all functions and methods needed to help you setup MonteCarloProblems over the combined initial conditions - parameter space
include("setup_mc_prob.jl")

# all function needed to evaluate the solutions of the MonteCarloProblem
include("eval_mc_prob.jl")

# all function and needed needed to evaluate (DBSCAN)-clustering
include("eval_clustering.jl")

# export all functions declared
export kuramoto_parameters, kuramoto, kuramoto_network_parameters, kuramoto_network, logistic_parameters, logistic, henon_parameters, henon, roessler_parameters, roessler_network, lotka_volterra, lotka_volterra_parameters
export myMCProblem, EqMCProblem, myMCSol
export setup_ic_par_mc_problem, eval_ode_run, eval_ode_run_repeat, eval_ode_run_inf, check_inf_nan
export distance_matrix, distance_matrix_dense, weighted_norm
export order_parameter

# internal functions, also exported for testing
export empirical_1D_KL_divergence, ecdf_pc

export curve_entropy
export k_dist, cluster_measures, cluster_n_noise, cluster_membership


end