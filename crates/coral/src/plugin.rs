use std::ops::Deref;

use rhai::{plugin::*, Array, CustomType};

pub(super) fn export(engine: &mut Engine) {
    engine.register_static_module("ensure", exported_module!(ensure).into());
    engine.register_static_module("env", exported_module!(env).into());
    engine.register_static_module("log", exported_module!(log).into());
    engine.build_type::<OsRelease>();
}

#[export_module]
mod ensure {}

#[export_module]
mod env {
    use std::process::Stdio;

    #[rhai_fn(return_raw)]
    pub fn execute_command(command: &str) -> Result<(), Box<EvalAltResult>> {
        let status = std::process::Command::new("sh")
            .arg("-c")
            .arg(command)
            .status()
            .map_err(|err| {
                Box::new(rhai::EvalAltResult::ErrorSystem(
                    err.to_string(),
                    Box::new(err),
                ))
            })?;

        if !status.success() {
            let message = format!("command failed: {status}");
            return Err(Box::new(rhai::EvalAltResult::ErrorSystem(
                message.clone(),
                message.into(),
            )));
        }

        Ok(())
    }

    #[rhai_fn(return_raw)]
    pub fn query_command(command: &str) -> Result<String, Box<EvalAltResult>> {
        let output = std::process::Command::new("sh")
            .arg("-c")
            .arg(command)
            .stdin(Stdio::inherit())
            .stdout(Stdio::piped())
            .stderr(Stdio::inherit())
            .output()
            .map_err(|err| {
                Box::new(rhai::EvalAltResult::ErrorSystem(
                    err.to_string(),
                    Box::new(err),
                ))
            })?;

        if !output.status.success() {
            let message = format!("command failed: {}", output.status);
            return Err(Box::new(rhai::EvalAltResult::ErrorSystem(
                message.clone(),
                message.into(),
            )));
        }

        let stdout = String::from_utf8(output.stdout).map_err(|err| {
            Box::new(rhai::EvalAltResult::ErrorSystem(
                err.to_string(),
                Box::new(err),
            ))
        })?;
        Ok(stdout)
    }
}

#[export_module]
mod log {
    #[rhai_fn()]
    pub fn trace(message: &str) {
        tracing::debug!(message);
    }

    #[rhai_fn()]
    pub fn debug(message: &str) {
        tracing::debug!(message);
    }

    #[rhai_fn()]
    pub fn info(message: &str) {
        tracing::info!(message);
    }

    #[rhai_fn()]
    pub fn warn(message: &str) {
        tracing::warn!(message);
    }

    #[rhai_fn()]
    pub fn error(message: &str) {
        tracing::error!(message);
    }
}

fn get_str<T, U>(f: impl Fn(&T) -> &str) -> impl Fn(&mut U) -> String
where
    U: Deref<Target = T>,
{
    move |v| f(v).to_owned()
}

fn get_opt_str<T, U>(f: impl Fn(&T) -> Option<&str>) -> impl Fn(&mut U) -> Dynamic
where
    U: Deref<Target = T>,
{
    move |v| match f(v) {
        Some(s) => s.to_owned().into(),
        None => ().into(),
    }
}

fn iter_to_array(iter: impl Iterator<Item = impl Into<Dynamic>>) -> Array {
    iter.map(|x| x.into()).collect()
}

#[derive(Debug, Clone)]
struct OsRelease(etc_os_release::OsRelease);

impl Deref for OsRelease {
    type Target = etc_os_release::OsRelease;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl CustomType for OsRelease {
    fn build(mut builder: rhai::TypeBuilder<Self>) {
        use etc_os_release as eor;
        builder
            .with_name("OsRelease")
            .on_debug(|v| format!("{v:?}"))
            .with_fn("open_os_release", || {
                eor::OsRelease::open().map(OsRelease).map_err(|err| {
                    Box::new(rhai::EvalAltResult::ErrorSystem(
                        err.to_string(),
                        Box::new(err),
                    ))
                })
            })
            .with_get("name", get_str(eor::OsRelease::name))
            .with_get("id", get_str(eor::OsRelease::id))
            .with_get("id_like", move |os_release: &mut OsRelease| {
                os_release
                    .0
                    .id_like()
                    .map(iter_to_array)
                    .unwrap_or_default()
            })
            .with_get("version", get_opt_str(eor::OsRelease::version))
            .with_get("version_id", get_opt_str(eor::OsRelease::version_id));
    }
}
