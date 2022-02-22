We should never upgrade angular all the way across the board. 

Instead its in hierarchical order - because many of those dependencies are just dependent upon one another. so several of them disappear.
If we encounter npm install errors because we have done an upgrade across the board, its very easy to fix this problem by just deleting node_modules and running npm install again.

This time though in order:

```bash
   npm install @angular/cli@latest -g
   ng update @angular/cli,
   ng update @angular/common
   npm install @angular/cdk@latest
   npm install @angular/material@latest
```

For example, in angular 12.2 there are warnings about chokidar if you run npm audit fix it won't do anything, and there are several others - you just have to wait till they fix them because they're dev dependencies.
However, we do not need to be as concered about dev dependencies that are not making their way to production. 

This example is taken from a live project current working versions:

```bash
 "@angular/animations": "~12.1.0",
    "@angular/cdk": "^12.2.0",
    "@angular/common": "~12.1.0",
    "@angular/compiler": "~12.1.0",
    "@angular/core": "~12.1.0",
    "@angular/fire": "^6.1.5",
    "@angular/forms": "~12.1.0",
    "@angular/platform-browser": "~12.1.0",
    "@angular/platform-browser-dynamic": "~12.1.0",
    "@angular/platform-server": "~12.1.0",
    "@angular/router": "~12.1.0",
    "@angular/service-worker": "~12.1.0",
    "@easypost/api": "^3.11.2",
    "@nguniversal/express-engine": "^12.1.0",
    "bootstrap": "^5.0.2",
    "dayjs": "^1.10.6",
    "express": "^4.15.2",
    "firebase": "^8.8.1",
    "ngx-quill": "^14.1.2",
    "quill": "^1.3.7",
    "quill-image-resize-module": "^3.0.0",
    "rxjs": "~6.6.0",
    "tslib": "^2.2.0",
    "zone.js": "~0.11.4"
}
```