use demand::Confirm;
use mlua::prelude::*;

fn confirm(
    _: &Lua,
    (question, yes, no): (Option<String>, Option<String>, Option<String>),
) -> LuaResult<bool> {
    let question = question.unwrap_or("Are you sure?".to_string());
    let yes = yes.unwrap_or("Yes".to_string());
    let no = no.unwrap_or("No".to_string());
    let confirm = Confirm::new(question).affirmative(yes).negative(no);
    let choice = match confirm.run() {
        Ok(confirm) => confirm,
        Err(e) => {
            if e.kind() == std::io::ErrorKind::Interrupted {
                println!("Dialog cancelled");
                false
            } else {
                panic!("Error: {}", e);
            }
        }
    };
    Ok(choice)
}

#[mlua::lua_module]
fn lumand(lua: &Lua) -> LuaResult<LuaTable> {
    let exports = lua.create_table()?;
    exports.set("confirm", lua.create_function(confirm)?)?;
    Ok(exports)
}
