# Experiments of Flexible Connections

This repository has the code to run experiments for different modeling connections between energy assets to represent the same energy system. We use [TulipaEnergyModel.jl](https://github.com/TulipaEnergy/TulipaEnergyModel.jl) to run the experiments. For a complete list of dependencies to run these experiments, please look at the Project.toml file in this repository.

## Activating and Running the Experiments

Start Julia REPL either via the command line or in the editor.

In the terminal, do:

```bash
cd /path/to/experiments-flexible-connection  # change the working directory to the repo directory if needed
julia                             # start Julia REPL
```

> **Note**:
> `julia` must be part of your environment variables to call it from the command line.


If you use VSCode, first open your cloned repository as a new project. Then open the command palette with <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd> (or <kbd>⇧</kbd> + <kbd>⌘</kbd> + <kbd>P</kbd> on MacOS) and use the command called `Julia: Start REPL`.

In Julia REPL, enter the package mode by pressing <kbd>]</kbd>.

In the package mode, activate and instantiate the project, then go back to Julia using the backspace and then include the file to run the experiments:

> **Warning**:
> If you want only to run a small test, then edit the `list_num_periods` in the `run-experiments.jl` to run just the first one or two periods. In addition, if you don't have Gurobi license, then consider removing it from the `list_of_solver` and packages, and then run it using HiGHS.

```julia
pkg> activate .   # activate the project
pkg> instantiate  # instantiate to install the required packages
# <backspace>
julia> include("run-experiments.jl")
```

The results will be exported by default in a file called `results_summary.csv`.

## License

This content is released under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0) License.
