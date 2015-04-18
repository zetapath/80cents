# 80cents
80cents is everything you need to sell anywhere (with your own io.js or nodejs servers)

## Installation
### Files

First, you need the following structure of files and folders:

```
.
├── environment
│   └── development.yml
├── 80cents.js
├── 80cents.yml
├── bower.json
├── gulpfile.coffee
├── package.json
```
80cents it's powered by [ZEN-server](https://github.com/soyjavi/zen-server). You can find proper settings for These files in the next links:

- [development.yml](https://github.com/cat2608/kedai/blob/master/environment/development.yml)
- [80cents.js](https://github.com/cat2608/kedai/blob/master/80cents.js)
- [80cents.yml](https://github.com/cat2608/kedai/blob/master/80cents.yml)
- [bower.json](https://github.com/cat2608/kedai/blob/master/bower.json)
- [gulpfile.coffee](https://github.com/cat2608/kedai/blob/master/gulpfile.coffee)
- [package.json](https://github.com/cat2608/kedai/blob/master/package.json)

### Commands
Install dependencies and bower components:

```bash
npm install
bower install
```
And compiles:

```bash
gulp init
```
Now start application running the following command:

```bash
node 80cents.js
```
### Running your store

Your shop is running at **http://localhost:1337**

## Quick start

Manage your account at **http://localhost:1337/admin**. After admin registration let's start with basic infromation about your store:

### Settings

First, start by setting the basic information about your store:

![image](https://dl.dropboxusercontent.com/u/41546005/80cents/Setting.1.1.png)

Then you can configure your shop address that will appear on your invoice as well as Time Zone, Currency, Uniy System and Weight Unit. Also, in this section, you can set your code from Google Analytics.

![image](https://dl.dropboxusercontent.com/u/41546005/80cents/Setting.1.2.png)

### Collections

Start building your store creating some collections, in this example we are building a shop for sell or buy tech devices so we need a *Mobile*, *Tablets* and *Desktop* categories.

From options on the left, select **Collections** and click on *Add a Collection* button.

![image](https://dl.dropboxusercontent.com/u/41546005/80cents/Collection.1.1.png)
















