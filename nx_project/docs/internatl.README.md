# UI Internationalization

## Description

The UI project currently supports translation and building of Spansih and Canadian French versions of the application. This document covers:

- Preparing templates for translation
- Generating translation files for an application
- Preparing translation files
- Building translated versions of an application

<br>
<hr>
<br>

## Preparing templates for translation

### **Marking displayed text for translation**

Static text is marked for translation by adding the `i18n` attribute to HTML tags. The `i18n` attribute is a custom attribute that is recognized by Angular at build time and is removed when the application is compiled.

When using the `i18n` attribute, it is best practice to add helpful descriptions and meanings to aid in the translation process. This is achieved by using the following pipe syntax:

```
i18n="<meaning>|<description>"
```

#### Example

```
<h1 i18n="greeting | A greeting at the top of the home page">
  Welcome to the home page!
</h1>
```

### **Translating text not for display**

In some instances, text is not displayed by default or at all. While using a `<span>` element to mark this text is effective, it creates an unnecessary DOM element. To avoid this, wrap the text in the Angular `<ng-container>` element.

#### Example

```
<ng-container i18n="hidden text sample | Sample text that doesn't display by default">
  This text is hidden by default, ng-container doesn't create a DOM element
</ng-container>
```

### **Marking HTML attributes for translation**

You can also mark HTML attributes for translation. For example, you may want a `placeholder` or `title` attribute to be translated. You can achieve this by using the following attribute syntax:

```
i18n-<attribute>="<meaning> | <description>"
```

#### Example

```
<input
  type="email"
  name="email"
  [(ngModel)]="user.email"
  placeholder="Enter your email here 123abc@example.com"
  i18n-placeholder="email input | Prompt for user to enter their email"
/>
```

### **Translating Plurals**

Translating plurals can be strange and difficult. Different languages use different grammatical contructions and rules for pluralization. To simplify, use [International Components for Unicode (ICU) plural clauses](http://userguide.icu-project.org/formatparse/messages) and [Common Locale Data Repository (CLDR)](http://cldr.unicode.org/index/cldr-spec/plural-rules) pluralization rules.

#### Example

You may want to display a message that relays how long it's been since data was updated expressed as "Updated X minutes ago". As a substitute you may want to show "Updated just now" or "Updated one minute ago". You can acomplish this with the following syntax:

```
<span i18n="Update time | Shows when data was last updated">
Updated {
  minutes,
  plural,
  =0 { just now }
  =1 { one minute ago }
  other { {{minutes}} minutes ago }
}
</span>
```

In the above syntax, there are 3 necessary parameters to consctruct the ICU clause:

- The first parameter `minutes` is bound to the Angular component property, which determines the number of minutes.
- The second parameter `plural` identifies the clause as a plural translation type
- The third parameter defines the pluralization category patterns and their matching values determined by the `minutes` parameter
  - `=0 { just now }` for zero minutes
  - `=1 { one minute ago }` for one minute
  - `other { {{minutes}} minutes ago }` for all other values
    - You can use Angular string interpolation to construct patterns

Depending on the language, the pluralization categories are as follows:

- =0 (or any other number)
- zero
- one
- two
- few
- many
- other

More information on pluralization categories [here](http://cldr.unicode.org/index/cldr-spec/plural-rules#TOC-Choosing-Plural-Category-Names)

### **Translating Alternates**

If you dispaly alternate text depnding on the value of the variable, all the alternates must be translated. To accomplish this, use the ICU `select` clause. The `select` clause is similar to the `plural` clause in the sense that it interprets the value of a variable and displays text depending on the value.

#### Example

Imagine you have a book review website that displays the book category. In development, the value of the `category` variable will always be in English, however you would want to translate the displayed text to the appropriate vernacular.

```
<span i18n="Category display | Shows the category of the book">
  Category: {
    category,
    select,
    fiction {fiction}
    nf {non-fiction}
    bio {biography}
  }
</span>
```

In the above example, the parameters are as follows:

- The first parameter `category` binds to the component property
- The second parameter `select` specifies that the ICU clause is a select clause for alternates
- The third parameter maps the value of `category` property to the text to display in curly brackets

### **Nesting ICU Clauses**

It is also possible to nest `select` clauses in `plural` clauses and vice versa.

#### Example

Suppose, like in the previous example, on your book review website you have a place to display a summary of how many books are classified by a certain category. You can nest the `select` clause in the `plural` clause to achieve this.

```
<span i18n="Books in category | Shows how many books are in a category">
  Total: {
    count,
    plural,
    =0 {no books}
    =1 {one {
      category,
      select,
      fiction {fiction}
      nf {non-fiction}
      bio {biography}
    } book}
    other { {{count}} {
      category,
      select,
      fiction {fiction}
      nf {non-fiction}
      bio {biographical}
    } books}
  }
</span>
```

In the above example, when the `count` property is equal to `6`, and the `category` property is equal to `bio`, the text would display, in English as:

- `Total: 6 biographical books`

### **For more information on translating plurals and alternates, visit the [official Angular documentation](https://angular.io/guide/i18n#mark-plurals-and-alternates-for-translation)**

<br>
<hr>
<br>

## Generating translation files for an application

When building an application for a particular locale or language, the `angular.json` file looks for XML files in the application folder that provide the necessary translations for elements marked with the `i18n` attribute in the templates.

Upon completing templates and deeming them ready for translation, there are simple NPM commands that can be run to automaically generate/update these XML files. They are as follows:

- `npm run translate` : generates/updates translation files for ALL apps

- `npm run translate:client` : generates/updates translation files for both client apps
- `npm run translate:internal` : generates/updates translation files for both internal apps

- `npm run translate:client-desktop` : generates/updates translation files for client-desktop app
- `npm run translate:client-mobile` : generates/updates translation files for client-mobile app
- `npm run translate:internal-desktop` : generates/updates translation files for internal-desktop app
- `npm run translate:internal-mobile` : generates/updates translation files for internal-mobile app

### When these commands are run, the `translate.sh` BASH script is triggered.

- If there are no translation files present, they are automatically created in appropriate app directory in the `locale` sub-directory.
  - For example, the directory tree for the internal-desktop app will look like this:
  ```
  -- apps
     |
     | -- client
     |    | -- desktop
     |    | -- mobile
     |
     | -- internal
     |    | -- desktop
     |    |    | -- src
     |    |    |    | -- app
     |    |    |    | -- locale
     |    |    |    |    | -- source.xlf (SOURCE ENGLISH VERSION)
     |    |    |    |    | -- source.es.xlf (SPANISH TRANSLATED VERSION)
     |    |    |    |    | -- source.fr.xlf (FRENCH TRANSLATED VERSION)
     |    |
     |    | -- mobile
  ```
- **If the translation files are already present, the script looks for any new XML tags and automatically inserts them into the Spanish and French translation files**

<br>
<hr>
<br>

## Preparing translation files

The NPM command runs Angular's extract-i18n command on the application and detects all HTML elements in the app that have the `i18n` attribute attached to them. In the resulting XML, `<trans-unit>` tags are constructed containing all the information about the element with the `i18n` attribute

### Simple text elements

#### Example

This is the XML `<trans-unit>` generated for an `<h1>` element that is a simple greeting

```
<trans-unit id="cf05cdc9aae09db8b879c536ca199cce49c8798b" datatype="html">
  <source>Hello there!</source>
  <context-group purpose="location">
    <context context-type="sourcefile">apps/client/desktop/src/app/app.component.html</context>
    <context context-type="linenumber">1</context>
  </context-group>
  <note priority="1" from="description"> Greeting at top of page</note>
  <note priority="1" from="meaning">Header greeting </note>
</trans-unit>
```

The important tags to note:

- `<source>` : The text displayed in the app
- `<context-group>` : data about the location of the source text
- `<note>` : additonal information about the source element in the HTML like meaning and description

To translate the `<source>` text, insert a `<target>` element beneath it, containing the translation

#### Example

The following would be in the source.es.xlf file for Spanish translation

```
<trans-unit id="cf05cdc9aae09db8b879c536ca199cce49c8798b" datatype="html">
  <source>Hello there!</source>
  <target>Hola!</target>
  <context-group purpose="location">
    <context context-type="sourcefile">apps/client/desktop/src/app/app.component.html</context>
    <context context-type="linenumber">1</context>
  </context-group>
  <note priority="1" from="description"> Greeting at top of page</note>
  <note priority="1" from="meaning">Header greeting </note>
</trans-unit>
```

### Plural translations

`plural` ICU clauses are extracted as separate `<trans-unit>` elements in the XML so they must also be translated, but the format is similar to simple text.

#### Example

This is an example of a `<trans-unit>` in the source.fr.xlf file

```
<trans-unit id="f7a406a81ac66ef094e0dac954f686b02fe74594" datatype="html">
  <source>
    {VAR_PLURAL, plural, =0 {just now } =1 {one minute ago } other {<x id="INTERPOLATION" equiv-text="{{minutes}}"/> minutes ago }}
  </source>
  <target>
    {VAR_PLURAL, plural, =0 {à l'instant} =1 {il y a une minute} other {il y a <x id="INTERPOLATION" equiv-text="{{minutes}}"/> minutes}}
  </target>
  <context-group purpose="location">
    <context context-type="sourcefile">apps/client/desktop/src/app/app.component.html</context>
    <context context-type="linenumber">2,3</context>
  </context-group>
</trans-unit>
```

### Translating Alternates

`select` ICU clauses are a bit different from standard text and `plural` clauses. Two separate `<trans-unit>` tags are generated. One for the text outside of the `select` clause, and one for the clause itself. Both must be translated.

#### Example

The following translations would be in the source.es.xlf file

```
/* Text outisde of select clause translation */

<trans-unit id="afc1340ba43f0ad07dba8aded747321c4c180294" datatype="html">
  <source>
    Category: <x id="ICU" equiv-text="{ category, select, fiction {fiction} nf {non-fiction} bio {biography} }"/>
  </source>
  <target>
    Categoría: <x id="ICU" equiv-text="{ category, select, fiction {fiction} nf {non-fiction} bio {biography} }"/>
  </target>
  <context-group purpose="location">
    <context context-type="sourcefile">apps/client/desktop/src/app/app.component.html</context>
    <context context-type="linenumber">2,4</context>
  </context-group>
  <note priority="1" from="description"> Shows the category of the book</note>
  <note priority="1" from="meaning">Category display </note>
</trans-unit>

/* select clause translation */

<trans-unit id="138cd6291a8b233cc213d7f3528e0884ac8f11e8" datatype="html">
  <source>
    {VAR_SELECT, select, fiction {fiction} nf {non-fiction} bio {biography}}
  </source>
  <target>
    {VAR_SELECT, select, fiction {ficción} nf {no ficción} bio {biografía}}
  </target>
  <context-group purpose="location">
    <context context-type="sourcefile">apps/client/desktop/src/app/app.component.html</context>
    <context context-type="linenumber">2,3</context>
  </context-group>
</trans-unit>
```

### **For more on working with tranlsation files, visit the [Angular official documentation](https://angular.io/guide/i18n#work-with-translation-files)**

<br>
<hr>
<br>

## Building Translated Version of an Application

When building a translated version of an application, the compiler looks at the `angular.json` file for configuration options. There are 3 different configurations that cause different builds.

### Bullding ALL translated locales/languages

- In the `angular.json` file, locate the project you are building
- Find the `options` object in the `build` object
- Change the `localize` property to `true`

### **IMPORTANT**: Using this configuration and serving the application locally will cause build failure. In development, use one of the configurations following this one

<br>

#### Example

```
/* angular.json */

"projects": {
  "client-desktop": {
    ...
    "architect": {
      ...
      "build": {
        ...
        "options": {
          ...
          "localize": true,
        },
      },
    },
  },
}
```

### Building specific translation locales/languages

- Change the `localize` property to an array of locales

#### Example

```
/* angular.json */

"projects": {
  "client-desktop": {
    ...
    "architect": {
      ...
      "build": {
        ...
        "options": {
          ...
          "localize": ["es"]
        }
      }
    }
  }
}
```

### Building none of the translation locales/languages

- Change the `localize` property to `false`

```
/* angular.json */

"projects": {
  "client-desktop": {
    ...
    "architect": {
      ...
      "build": {
        ...
        "options": {
          ...
          "localize": false,
        },
      },
    },
  },
}
```
