using TulipaEnergyModel
using JuMP
using HiGHS
using Gurobi
using CSV
using DataFrames
using Random

# Set the seed for the random number generator
Random.seed!(821020) # seed for first 10 runs
#Random.seed!(900205) # seed for next 10 runs
#Random.seed!(390311) # seed for last 10 runs

# Include file with functions
include("functions.jl")

# Define lists of cases, solvers, number of rep periods, and seeds
list_of_cases = ["Norse-asset-to-asset", "Norse-classic", "Norse-classic-two-flows"]
list_of_solver = ["Gurobi", "HiGHS"];
list_num_periods = [1, 24, 168, 672, 4032, 8760, 17520, 26280, 35040];
list_of_seeds = rand(1:100000, 10);

# Define input and output file names
INPUT_FOLDER = joinpath(pwd(), "case-studies-data");
OUTPUT_FILE_NAME = "results_summary.csv";

# Create an empty DataFrame to store the results
results_df = DataFrame(;
    Case_Study = String[],
    Solver = String[],
    Method = String[],
    Num_Rep_Periods = Int[],
    Seed = Int[],
    Time_To_Build_Model = Float64[],
    Objective_Function_Value = Float64[],
    Num_Variables = Int[],
    Num_Constraints_Including = Int[],
    Num_Constraints_Excluding = Int[],
    Solve_Time = Float64[],
);

for case_study in list_of_cases
    dir = joinpath(INPUT_FOLDER, case_study)
    for solver in list_of_solver
        optimizer, parameters = define_solver_parameters(solver)
        for num_periods in list_num_periods
            for seed in list_of_seeds
                println(
                    "----" *
                    case_study *
                    "_" *
                    solver *
                    "_" *
                    "Barrier" *
                    "_" *
                    string(num_periods) *
                    "h" *
                    "_" *
                    string(seed),
                )
                create_rep_periods_data_csv(dir, num_periods)

                if solver == "Gurobi"
                    # add to the parameters dictionary the seed for the random number generator
                    parameters["Seed"] = seed
                end

                energy_problem = create_energy_problem_from_csv_folder(dir)
                _, time_to_build = @timed create_model!(energy_problem; write_lp_file = false)
                solve_model!(energy_problem, optimizer; parameters = parameters)

                # Append a new row to the DataFrame
                push!(
                    results_df,
                    (
                        case_study,
                        string(optimizer),
                        "Barrier",
                        num_periods,
                        seed,
                        time_to_build,
                        energy_problem.objective_value,
                        num_variables(energy_problem.model),
                        num_constraints(
                            energy_problem.model;
                            count_variable_in_set_constraints = true,
                        ),
                        num_constraints(
                            energy_problem.model;
                            count_variable_in_set_constraints = false,
                        ),
                        solve_time(energy_problem.model),
                    ),
                )

                if solver == "HiGHS"
                    # HiGHS does not support the seed parameter
                    break
                end
            end
        end
    end
end

# Write the DataFrame to a CSV file
CSV.write(OUTPUT_FILE_NAME, results_df);
