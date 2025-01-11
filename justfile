_default:
    just --list

link:
    ln -s ./target/debug/liblumand.dylib ./lumand.so

test:
    lua -e 'require("lumand").confirm()'
    lua -e 'require("lumand").confirm("Are you sure boi?")'
    lua -e 'require("lumand").confirm("Really?", "duh", "nvm...")'
    lua -e 'if require("lumand").confirm() then print"Affirmative" else error"ERROR" end'

# compares version of crate and local repo
@compare:
    echo -n 'CRATE: '
    cargo search lumand 2>/dev/null | rg --fixed-strings -- lumand || true
    echo -n 'LOCAL: '
    head --lines 5 ./Cargo.toml | rg --no-multiline --fixed-strings -- version || true

