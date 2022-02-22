# Docker Angular Seed

The following steps are based on the assumption that the tag used to create the image during build is the same image referenced in the docker-compose file.
After successfully running the newly created image, the container ID is used to open an CLI session, tar the contents of the app directory before copying them back to the local host. 

Steps
1) docker build -f Dockerfile -t docker-app . 
2) docker run -d docker-app
3) docker exec -it cdc0c366c47f428967dbc829efeeba31557cb9c74d1c6442ef6469fe9abebffa /bin/sh
4) docker cp cdc0c366c47f:/app/app.tar.gz .
5) tar -xzvf app.tar.gz
6) docker-compose up

This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 13.2.4.

## Development server

Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`. The app will automatically reload if you change any of the source files.

## Code scaffolding

Run `ng generate component component-name` to generate a new component. You can also use `ng generate directive|pipe|service|class|guard|interface|enum|module`.

## Build

Run `ng build` to build the project. The build artifacts will be stored in the `dist/` directory.

## Running unit tests

Run `ng test` to execute the unit tests via [Karma](https://karma-runner.github.io).

## Running end-to-end tests

Run `ng e2e` to execute the end-to-end tests via a platform of your choice. To use this command, you need to first add a package that implements end-to-end testing capabilities.

## Further help

To get more help on the Angular CLI use `ng help` or go check out the [Angular CLI Overview and Command Reference](https://angular.io/cli) page.
