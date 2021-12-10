# gsa-classroom-tools

Tools for working with GSA projects with GitHub Classroom

## Setting up projects

This [`gsa-project-base`](https://github.com/birc-gsa/gsa-project-base) repo collects common code and information shared between all projects. To use it, you need to build a specific one. To do that, first create a new repository and clone it to your own machine. There isn't a README.md file in this repository, so you can add that to the project repo, but you should not add a .gitignore, as that should come from the build-specific mixin.

In the new project repo, we need to setup a remote pointer to this base repo.

```sh
> git remote add base https://github.com/birc-gsa/gsa-project-base
> git fetch base
> git merge base/main --allow-unrelated-histories
```

Now you have a connection to the base-repo so you can fetch and merge updates in the future. Any time you need to pull down changes from the base repo, repeat

```sh
> git fetch base
> git merge base/main
```

In the new project, you can describe the specific project; use README.md for that, and you can configure the testing setup specific to the project. As a minimum, you need to add `.gsa/test-test.yml`. It is currently empty, but it must be populated for the testing workflow to function. An example could be this:

```yaml
tools:
  TM-Naive:
    map: "gsa search {genome} {reads} -o {outfile} exact naive"
  TM-Border:
    map: "gsa search {genome} {reads} -o {outfile} exact border"
  search:
    map: "{root}/search {genome} {reads} > {outfile}"
  
reference-tool: TM-Naive

genomes:
  length: [100, 500, 1000]
  chromosomes: 10

reads:
  number: 10
  length: [10, 50]
  edits: 0
```

A project can't be used on its own. You need to combine it with a build mixin that sets up the necessary templates for building code and testing it.

## Setting up build mixins

A build mixin repo should be named `build-<configuration>-mixin` and should contain a build action in `.github/actions/build/action.yml`, e.g.

```yaml
name: 'Configure and build'
description: 'Setting up and building the project'
runs:
  using: "composite"
  steps:
    - name:  Building project files
      run:   make
      shell: bash
```

and a testing workflow in `.github/workflows/build-ci.yml`, e.g.

```yaml
name: Makefile CI

on: [push]

jobs:
  make-testing:
    name: Consistency testing from make file
    runs-on: ubuntu-latest
    steps:
      - name: Checking out repository
        uses: actions/checkout@v2

      - name: Building project
        uses: ./.github/actions/build

      - name: Checking
        run:  make test
```

In addition to this, it could contain some minimal setup for building for this environment. This isn't strictly necessary, since we likely will have to adapt it for each project anyway. But still...


## Creating a concrete project

When you have both a project and a build mixin you can create a repo you can use for assignment templates using the `mix-project.sh` script.

Run it as

```sh
> mix-project.sh project-name build-mixin
```

where `build-mixin` doesn't contain the `build-` and `-mixin` part. A run as above is a dry-run that shows the commands that it will execute. Check that they are okay, and then run it as

```sh
> mix-project.sh -r project-name build-mixin
```

to run it for real.

Run it from outside an existing repo clone because it will create a new dir and a repository in it. You will have to make it a template yourself, because I don't know how to do that on the command-line.

From this project repo you can fetch new project data from `proj/main` and new build data from `build/main`.
