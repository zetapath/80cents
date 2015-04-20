## 80cents
A real and easy NodeJS service for create ecommerce platforms.
http://80cents.org

- [Instalation](#instalation)
  - []
  - [Files](#files)
  - [Commands](#commands)
  - [Running your store](#running-your-store)
- [Quick start](#quick-start)
  - [Settings](#settings)
  - [Collections](#collections)
  - [Products](#products)
  - [Discounts](#discounts)
  - [Pages](#pages)
  - [Payments](#payments)
- [Customize](#)
  - [Theme](#)
  - [Templates](#)
  - [JavaScript](#)

---
### Installation
In less than five minutes you can have your ecommerce up and ready. 80cents is registered as a Node package with NPM. You can install the latest version of 80cents with the command:

```
npm install 80cents
```

#### Files
After install NPM package, you need create the following structure of files and folders:

```
.
├── environment
│   ├── development.yml
│   └── ..
├── 80cents.js
├── 80cents.yml
├── bower.json
├── gulpfile.coffee
├── package.json
```

80cents it's powered by [ZEN-server](https://github.com/soyjavi/zen-server). You can find proper settings for these files in the next links:

- [development.yml](https://github.com/cat2608/kedai/blob/master/environment/development.yml)
- [80cents.js](https://github.com/cat2608/kedai/blob/master/80cents.js)
- [80cents.yml](https://github.com/cat2608/kedai/blob/master/80cents.yml)
- [bower.json](https://github.com/cat2608/kedai/blob/master/bower.json)
- [gulpfile.coffee](https://github.com/cat2608/kedai/blob/master/gulpfile.coffee)
- [package.json](https://github.com/cat2608/kedai/blob/master/package.json)

#### Commands
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

#### Running your store
Your shop is running at **http://localhost:1337**


---
### Quick start
Manage your account at **http://localhost:1337/admin**. After admin registration let's start with basic infromation about your store:

#### Settings
In this section you can edit information about your store as Name, Homepage, Metas and e.mail addresses to contact.

![image](https://dl.dropboxusercontent.com/u/41546005/80cents/Setting.1.1.png)

Then you can configure your shop address that will appear on your invoice as well as Time Zone, Currency, Uniy System and Weight Unit. Also, in this section, you can set your code from Google Analytics.

![image](https://dl.dropboxusercontent.com/u/41546005/80cents/Setting.1.2.png)

#### Collections
Start building your store creating some collections, in this example we are building a shop for sell or buy tech devices so we need a *Mobile*, *Tablets* and *Desktop* categories.

Select **Collections** from aside and click on *Add a Collection* button. Fill the form and after saving basic information you can upload images for this category.

![image](https://dl.dropboxusercontent.com/u/41546005/80cents/Collection.1.1.png)

#### Products
The next step is to add products to categories. Select **Products** from aside and create a new one and edit product's information.

![image](https://dl.dropboxusercontent.com/u/41546005/80cents/Products.1.1.png)

### Discounts
Coming soon

### Pages
Coming soon

### Payments
Coming soon

---
### Customize
Coming soon
