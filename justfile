_default:
    just --list

@build:
    cargo rustc -- -C link-arg=-undefined -C link-arg=dynamic_lookup

link:
    rm ./lumand.so || true
    ln -s ./target/debug/liblumand.dylib ./lumand.so

test: build
    lua -e 'require("lumand").confirm()'
    lua -e 'require("lumand").confirm("Are you sure boi?")'
    lua -e 'require("lumand").confirm("Really?", "duh", "nvm...")'
    lua -e 'if require("lumand").confirm() then print"Affirmative" else error"ERROR" end'

# compares version of crate and local repo
@compare:
    echo -n 'CRATE: '
    cargo search lumand | rg --fixed-strings -- lumand || true
    echo -n -e '\nLOCAL: '
    head --lines 5 ./Cargo.toml | rg --no-multiline --fixed-strings -- version || true

