# Angular UI

## Introduction

All Angular UI projects and efforts are contained in this monorepo. It serves as a singular repository with buildable apps and libraries, with clearly defined APIs that serve as the foundation for those apps.

This project was generated and is developed using [Nx](https://nx.dev) (v12.0.8) and [Angular](https://angular.io/docs) (v11.0.2)

<br>
<hr>
<br>

## Additional Resources

- [Troubleshooting Common Problems](docs/troubleshoot.README.md)
- [Internationalization](docs/internatl.README.md)

<br>
<hr>
<br>

## Getting Started

This project uses NPM to manage dependencies. To get started, clone this repo to your local machine and run

```
npm install
```

If you need to install Node.js, download it [here](https://nodejs.org/en/)

<br>
<hr>
<br>

## Interacting with the project

Use the Nx CLI to issue various commands to interact with an individual application

```
App Names:
client-desktop
client-mobile
internal-desktop
internal-mobile
```

### **Build an application**

Compiles an application into an output directory named dist/

```
nx build <app-name> [options]

Example:
nx build internal-desktop --prod
```

- Common Options
  - --prod : compile a production build of the app
  - --baseHref : base URL for the app being built (default: '/')
  - --index : HTML file which will contain the application
  - --main : the full path for the main entry point to the app, relative to the current workspace.
  - --aot : Build using [Ahead of Time Compilation](https://angular.io/guide/aot-compiler) (default with Angular 9+)
  - --help : show help information
- For more options, [click here](https://nx.dev/latest/angular/cli/build)

### **Serve application locally**

Builds and serves an application, rebuilding on file changes

```
nx serve <app-name> [options]

Example:
nx serve internal-desktop --open --port=8080
```

- By default, application will be served at [localhost:4200](http://localhost:4200)
- Common Options:
  - --open : automatically open the application in a browser
  - --host : host to listen on (default: localhost)
  - --port : port to listen on (default: 4200)
  - --help : show help
- For more options, [click here](https://nx.dev/latest/angular/cli/serve)

### **Run Unit Tests**

Runs unit tests in a project using [Jest](https://jestjs.io)

```
nx test <app-name> [options]

Example:
nx test internal-desktop --watch
```

- **Run `affected:test` to only run unit tests affected by any file changes**
- Common Options:
  - --watch : watch files for changes and rerun tests realted to changed files
  - --help : show help information
- For more options, [click here](https://nx.dev/latest/angular/cli/test)

### **Run e2e Tests**

Builds and serves an application, then runs end-to-end tests using [Cypress](https://www.cypress.io).

```
nx e2e <app-name>-e2e [options]

Example:
nx e2e internal-desktop-e2e --watch
```

- **Run `affected:e2e` to only run e2e tests affected by any file changes**
- Common Options
  - --watch : open the Cypress test runner and automatically rerun tests when files are updated
  - --headless : whether or not to open the Cypress application to run the tests. If set to 'true', will run in headless mode
  - --help : show help information
- For more options, [click here](https://nx.dev/latest/angular/cli/e2e)

### **Linting**

Runs linting tools on application or library code in a given project folder using the configured linter.

```
nx lint <app-name OR lib-name> [options]

Example:
nx lint internal-desktop --fix
```

- Common Options
  - --fix : Fixes linting errors
  - --force : forces success even if there are linting errors
  - --help : show help information
- For more options, [click here](https://nx.dev/latest/angular/cli/lint)

<br>
<hr>
<br>

## Create a new application

When using Nx, you can create multiple applications and libraries in the same workspace.

```
nx g @nrwl/angular:app <name>

Example:
nx g @nrwl/angular:app new-app --directory=newappdir/desktop --strict
```

- Common Options:
  - --directory : the directory of the new application
  - --routing : generate a routing module
  - --strict : create application with stricter type checking and build optimizations
  - --help : show help information

## Create a library

Libraries are shareable across applications and other libraries

```
nx g @nrwl/angular:lib <name>

Example:
nx g @nrwl/angular:lib new-app-lib --directory=newapp/desktop --strict
```

- Common Options
  - --directory : the directory where the new library should be placed
  - --strict : create library with stricter type checking and build optimizations
  - --help : show help information

## Create a Component

Components should be generated in appropriate libraries so they can be shared and to keep applications as lean as possible

```
nx g @nrwl/angular:comp <name> --project=<lib-name>

Example:
nx g @nrwl/angular:comp header --project=shared-components
```

- Common Options:
  - --prefix : the prefix to apply to the generated component selector
  - --export : the project's NgModule automatically exports the component
  - --help : show help information

## Understand your workspace

Display an interactive dependency graph for the entire project

```
nx dep-graph [options]
```

- Common Options:
  - --file : specify an output file (served in browser by default)
  - --port : bind the dependency graph server to specific port
  - --help : show help information

<br>
<hr>
<br>

## Project Architecture

```
| drivendata-ui
|
|--- apps/
|    |--- client/
|    |    |--- desktop/
|    |    |--- desktop-e2e/
|    |    |--- mobile/
|    |    |--- mobile-e2e/
|    |--- internal/
|    |    |--- desktop/
|    |    |--- desktop-e2e/
|    |    |--- mobile/
|    |    |--- mobile-e2e/
|    |
|--- libs/
|    |--- client/
|    |    |--- desktop/
|    |    |    |--- feature-name/
|    |    |    |    |--- +state/
|    |    |    |    |--- components/
|    |    |    |    |--- services/
|    |    |    |    |--- guards/
|    |    |    |    |--- pipes/
|    |    |    |    |--- testing/
|    |    |    |--- .../
|    |    |    |    |--- .../
|    |    |--- mobile/
|    |    |    |--- feature-name/
|    |    |    |    |--- .../
|    |    |    |--- .../
|    |    |    |    |--- .../
|    |    |
|    |--- internal/
|    |    |--- desktop/
|    |    |    |--- feature-name/
|    |    |    |    |--- .../
|    |    |--- mobile/
|    |    |    |--- feature-name/
|    |    |    |    |--- .../
|    |    |    |--- .../
|    |    |    |    |--- .../
|    |    |
|    |--- shared/
|    |    |--- feature-name/
|    |    |    |--- .../
|    |
|--- tools/
|--- docs/
|--- package.json
|--- package-lock.json
|--- angular.json
|--- nx.json
|--- tsconfig.base.json
|--- decorate-angular-cli.js
|--- jest.config.js
|--- jest.preset.js
|--- README.md
|--- .editorconfig
|--- .eslintrc.json
|--- .gitignore
|--- .prettierignore
|--- .prettierrrc
```
