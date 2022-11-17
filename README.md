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
    - [x] Make, clone and commit to new repo
    - [x] Mock the graph locally in console
    - [x] Actually display a frame on github
    - [x] Shading instead of 0 or 1
    - [ ] Clean up abstractions
- [ ] Persist game state between program execution so it can run once daily etc.
- [ ] Schedule execution
- [ ] DotEnv Configs to make it deployable
- [ ] Deploy it somewhere?
- [ ] Screenshot history?

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

To get around clone call freezing, changed to creating local git repo and then add the github remote to it before pushing. Now it seems the push has the same problem. Playing around with it something must be off with the protocol/url/port used for the remote.

git://github.com/contribgraph/display_f03910.git
git@github.com:contribgraph/display_e2ff7c.git

And there it is, I was using the deprecated (by github) git_url instead of the ssh_url.

Pushing using the ruby git gem isn't working with permissions issues right now, not sure if the custom ssh script it being picked up correctly. System call to push with manual ssh script wrapper works.
