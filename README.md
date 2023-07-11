# Auto Notebook

Automatically create a notebook with mdbooks.

## Requirements
- Rust
- Linux distro with Bash (this was tested on PopOS 22.04)

## Defaults

Directory | Default | Description
--- | --- | ---
template directory | `pre_src` | Directory for content templates
content directory | `src` | Directory for content
output directory | `home/w3/public` | Directory that mdbook builds to

# Setup

## [Install Rust and Cargo](https://www.rust-lang.org/tools/install)

```sh
# Install Rust, comes with cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# Verify installation
cargo version
```


## Install SUMMARY.md auto generator
```sh
cargo install mdbook-auto-gen-summary
# Go to root of project
# Generate SUMMARY.md for `src`` directory
mdbook-auto-gen-summary gen src
```

## Add wiki content

Create `pre_src` and `src` directories

```sh
# Add content you want to create templates for here
mkdir pre_src
# Add content you don't need templating for here
mkdir src
```

###  Use template for dynamic variables
If you want to do dynamic variable expansion like add a date the page was built you can use the draft folder to preprocess files before they hit  `src` by adding `.env` files in `pre_src`.

Create a `.env` file with a corresponding `.md` file

e.g.
`template_example.env`
```
# these variables will be expanded with `subst` command to its respective file

title="# Expanded Title"

content="This is some content that will get expanded by `subst`"

link="https://example.com"
```

`template_example.md`
```
${title}

${content}

${link}
```

```sh
# Something like this is run for every file in the directory pre_src
$ envsubst < template_example.md > processed_template_example.md
```


`src/posts/mypost.md`
```
# Hello World
```

`src/notes/mynotes.md`
```
# This is a note
```



## Build book

Run `./deploy.sh`

The website will be built into `book` folder which will then be copied to `home/w3/public`

## Serve the notebook as a web page

Make sure you have a server that can serve html content in `home/w3/public`.

`make serve` or `mdbook serve`

You can also use [Github Pages](https://pages.github.com/) if you want to host it on Github.

---

Powered by [mdbooks](https://github.com/rust-lang/mdBook)

LICENSE
---

MIT or Apache 2.0

## TroubleShooting

## Check for utf8 errors
`mdbook-auto-gen` will error if there are files with non-utf-8 characters.

To check a folder and all its files inside for invalid utf-8: `grep -raxv ".*"`

`make chk` will check the `src` directory for problems