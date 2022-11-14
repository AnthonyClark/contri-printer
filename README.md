# Setup

## Ruby
Using ASDF to manage Ruby version

`bundle install` to setup gems as required
`rake run` to run
`rake test` to test

## dotenv (.env file in repo root)
`GITHUB_TOKEN=your_token_here`

## TODO:
- [x] Basic Game of Life working in console
- [x] Wrapping edges
- [x] Use Raketasks for running
- [ ] Git commit printer
    - [x] Be able to add contributions
    - [x] Clear contributions by deleting repo
    - [ ] Make, clone and commit to new repo
    - [ ] Mock the graph locally in console
    - [ ] Shading instead of 0 or 1
- [ ] Persist game state between program execution so it can run once daily etc.
- [ ] Schedule execution
- [ ] DotEnv Configs to make it deployable
- [ ] Deploy it somewhere?

- [ ] Different input to printer? Maybe small bitmap image shaded in?

### Notes:
These work for second user done manually, not yet all working through Ruby-Git
```sh
GIT_SSH_COMMAND='ssh -i ~/.ssh/id_contrigraph_user_ed25519 -o IdentitiesOnly=yes' git clone git@github.com:contribgraph/display.git

GIT_SSH_COMMAND='ssh -i ~/.ssh/id_contrigraph_user_ed25519 -o IdentitiesOnly=yes' git push

git commit --author="contribgraph <117421137+contribgraph@users.noreply.github.com>" --allow-empty -m "whatever"

@client.create_repository('FooTestRepo', private: false)
@client.delete_repo('contribgraph/FooTestRepo')
```

Oh dear I think the repo has to be deleted to clear contributions from the graph :(

Octokit gem gives nice API to do this thankfully.
http://octokit.github.io/octokit.rb/Octokit/Client/Repositories.html#create_repository-instance_method

Why not create commits with Octokit to simplify git interactions? Each Octokit commit creation is an API call, will be v. slow for many commits versus local commits with one push.

Something is freezing in repo clone call at the moment.
