# What is this?

Just having some fun displaying Conway's Game of Life on the Github Contributions graph.

# Setup

## Ruby
Using ASDF to manage Ruby version.

`bundle install` to setup gems as required
`rake start` to run from scratch
`rake step` to run a tick iteration
`rake git:delete` to delete github display repo
`rake test` to run any tests

## dotenv (.env file in repo root)
```
GITHUB_TOKEN=your_token_here
SSH_KEY_PATH=~/.ssh/path_to_ssh_key
GIT_CONTRIBUTER=some name <email@example.com>
```

## Generating demo gif

Using [vhs](https://github.com/charmbracelet/vhs), a tool built in Go to easily record and share CLI demos.

```
cd docs
vhs < console.tape
```

## TODO:
- [x] Basic Game of Life working in console
- [x] Wrapping edges
- [x] Use Raketasks for running
- [ ] Git commit printer
    - [x] Be able to add contributions
    - [x] Clear contributions by deleting repo
    - [x] Make, clone and commit to new repo
    - [x] Mock the graph locally in console
    - [x] Actually display a frame on github
    - [x] Shading instead of 0 or 1
    - [x] Functional `step` on github display
    - [ ] Re-use the same local git repo as buffer for read and write
    - [ ] Simplify runner interface allowing start from existing execution
- [ ] Record VHS gif when I can actually install the dependencies properly
- [ ] Schedule execution
- [ ] Deploy it somewhere?
- [ ] Screenshot history?
