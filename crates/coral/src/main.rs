use std::{env, path::PathBuf};

use clap::Parser as _;
use rhai::{module_resolvers::FileModuleResolver, Engine, EvalAltResult};

mod plugin;

#[derive(Debug, clap::Parser)]
struct Args {
    /// The script file to run
    #[clap()]
    script_file: Vec<PathBuf>,
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = Args::parse();

    if env::var_os("RUST_LOG").is_none() {
        env::set_var("RUST_LOG", "info");
    }

    tracing_subscriber::fmt()
        .with_env_filter(tracing_subscriber::EnvFilter::from_default_env())
        .with_writer(std::io::stderr)
        .try_init()
        .map_err(|err| err as Box<dyn std::error::Error>)?;

    let mut engine = Engine::new();

    let resolver = FileModuleResolver::new_with_path("./lib/");
    engine.set_module_resolver(resolver);

    plugin::export(&mut engine);

    for path in args.script_file {
        run_script(&engine, path)?;
    }

    Ok(())
}

fn run_script(engine: &Engine, path: PathBuf) -> Result<(), Box<EvalAltResult>> {
    engine.run_file(path)?;
    Ok(())
}
