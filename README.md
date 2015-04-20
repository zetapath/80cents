## 80cents
A real and easy NodeJS service for create ecommerce platforms.
http://80cents.org

- [Instalation](#instalation)
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
  - [Endpoints](#)

---
### Installation
In less than five minutes you can have your ecommerce up and ready. 80cents is registered as a Node package with NPM. You can install the latest version of 80cents with the command:

```
npm install 80cents
```

#### Files
After install NPM package, you need create the following structure of files and folders. If you want you can [download](https://github.com/zetapath/80cents.site/raw/gh-pages/example.zip) our example:

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

- [development.yml](https://github.com/zetapath/80cents.site/blob/gh-pages/example/environment/development.yml) (one of your environments for run the current instance)
- [80cents.js](https://github.com/zetapath/80cents.site/blob/gh-pages/example/80cents.js) (main running NodeJS file)
- [80cents.yml](https://github.com/zetapath/80cents.site/blob/gh-pages/example/80cents.yml) (configuration of your 80cents instance)
- [bower.json](https://github.com/zetapath/80cents.site/blob/gh-pages/example/bower.json) (bower dependencies)
- [gulpfile.coffee](https://github.com/zetapath/80cents.site/blob/gh-pages/example/gulpfile.coffee) (gulp tasks config file)
- [package.json](https://github.com/zetapath/80cents.site/blob/gh-pages/example/package.json) (node package dependencies)

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
Manage your account at **http://localhost:1337/admin**. After admin registration let's start with basic information about your store:

#### Settings
In this section you can edit information about your store as Name, Homepage, Metas and Mail addresses for contact. Also, you can configure your shop address. This information will appears on your invoice.

![image](https://dl.dropboxusercontent.com/u/41546005/80cents/Setting.1.1.png)

Then you can edit Standard and Format for products details.

![image](https://dl.dropboxusercontent.com/u/41546005/80cents/Setting.1.2.png)

#### Collections
Start building your store creating some collections, in this example we are building a shop for sell or buy tech devices so we need a *Mobile*, *Tablets* and *Desktop* categories.

Select **Collections** from aside and click on *Add a Collection* button. Fill the form and after saving basic information you can upload images for this category.

![image](https://dl.dropboxusercontent.com/u/41546005/80cents/Collection.1.1.png)

#### Products
The next step is to add products to categories. Select **Products** from aside and create a new one and edit product's information.

![image](https://dl.dropboxusercontent.com/u/41546005/80cents/Products.1.1.png)

#### Discounts
In this section you can define discounts for your customers. Define a code, description and if the discount is in percent or money. Also, you can configure your discount for entire order, collection or product.

![image](https://dl.dropboxusercontent.com/u/41546005/80cents/Discount.1.1.png)

#### Pages
Use this section to add static pages as *About*, *Shipping*, *Returns*, *Terms of use* or any other that you need.

Links for *Pages* are shown at footer. You can check *Header Menu* box for have links at header.

![image](https://dl.dropboxusercontent.com/u/41546005/80cents/Pages.1.1.png)

#### Payments
With 80 cents you can choose as payment between PayPal or Stripe. You just need configure your keys.

![image](https://dl.dropboxusercontent.com/u/41546005/80cents/Payments.1.1.png)

---
### Customize
Coming soon

#### Theme

#### Templates

#### Endpoints
