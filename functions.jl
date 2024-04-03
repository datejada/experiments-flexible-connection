function create_rep_periods_data_csv(input_folder::String, num_time_steps::Int)
    # Create a DataFrame with the specified data
    df =
        DataFrame(; c1 = ["id", 1], c2 = ["num_time_steps", num_time_steps], c3 = ["resolution", 1])

    # Define the CSV file name
    csv_file_name = joinpath(input_folder, "rep-periods-data.csv")

    # Save the DataFrame to a CSV file
    return CSV.write(csv_file_name, df)
end

function define_solver_parameters(solver::String)
    parameters = Dict{String, Any}()
    if solver == "Gurobi"
        optimizer = Gurobi.Optimizer
        parameters = Dict("OutputFlag" => 1, "Method" => 2)
    else
        optimizer = HiGHS.Optimizer
        parameters = Dict("output_flag" => true, "solver" => "ipm")
    end
    return optimizer, parameters
end
