# BeI-MultiModel
## Introduction
This is a personal project, by Bert Sarens and myself, meant for the Intersystems Multi-model contest.

The goal of this application was to build a product filter that was capable of filtering large amounts of products on a large amount of filters.
This project uses objects, some sql access to these objects and plain global access for the indexing.

We've used a IRIS backend that is called via a REST-API from a react frontend application.

As a test we've tried this on 1.000.001 products with about 100 filter posibilities.
forcing a product to be the last entry and specifying a filter that would only match the last entry took 0.6 seconds to yield the result.

## ZPM  
The code for this application can be installed through ZMP. This will install all the classes needed and will run a seed command to seed a demo database containing 100000 records.

Attention: The react front-end app is not included in the ZPM package.

## Dependencies
This project has some dependencies:
   * Node
   * NPM
   * Docker
   * Docker-Compose  

## Set-up
To setup this code follow these steps:
1. clone the repository to a folder on your computer
   ``` 
   git clone https://github.com/ivove/BeI-MultiModel.git
   ```
   next check out the 1.1.1 release
   ```
   git checkout R_1.1.1
   ```
2. Create a folder "files" under the root directory of the repo you just cloned 
   ``` 
   cd BeI-Multimodel #only do this if you haven't already entered the directory
   mkdir files
   ```
3. Start the docker container
   ``` 
   docker-compose up -d
   ```
4. Install the application and seed some testdata
   ``` 
   npm run seed
   ```
5. install the required frontend packages to run the app
   ```
   cd my-app
   npm install
   ```

These steps should get you ready to start testing.

## Testing the app
The following is a short description on how to test the application.

First step is to start the application. We can do this from a terminal prompt by starting in the my-app directory and executing the following:
```
   npm run start
```
this should start a webserver listening on port 3000 and automaticly opening a browser showing the page

The following image briefly shows the interface. With the posibility to 
* filter on some filters (for exemple screen size)
   ![demo-filter](https://raw.githubusercontent.com/ivove/BeI-MultiModel/R_1.1.0/images/demo-filter.gif)
* search on the name
   ![demo-search](https://raw.githubusercontent.com/ivove/BeI-MultiModel/R_1.1.0/images/demo-search.gif)   
* change the sortorder
   ![demo-sort](https://raw.githubusercontent.com/ivove/BeI-MultiModel/R_1.1.0/images/demo-sort.gif)
* use the pageing to change the page
   ![demo](https://raw.githubusercontent.com/ivove/BeI-MultiModel/R_1.1.0/images/demo-page.gif)
* setting the page size
   ![demo](https://raw.githubusercontent.com/ivove/BeI-MultiModel/R_1.1.0/images/demo-pagesize.gif)

## Multi-model parts:

* Key-Value:
    - https://github.com/ivove/BeI-MultiModel/blob/298c20a8ae833d334d7b8702e71ef4198c9e1355/src/BeI/API.cls#L104
    - https://github.com/ivove/BeI-MultiModel/blob/298c20a8ae833d334d7b8702e71ef4198c9e1355/src/BeI/Agent.cls#L137
* SQL:
    - https://github.com/ivove/BeI-MultiModel/blob/298c20a8ae833d334d7b8702e71ef4198c9e1355/src/BeI/Agent.cls#L127
    - https://github.com/ivove/BeI-MultiModel/blob/298c20a8ae833d334d7b8702e71ef4198c9e1355/src/BeI/Product.cls#L22
* Object:
    - https://github.com/ivove/BeI-MultiModel/blob/298c20a8ae833d334d7b8702e71ef4198c9e1355/src/BeI/API.cls#L197
    - https://github.com/ivove/BeI-MultiModel/blob/298c20a8ae833d334d7b8702e71ef4198c9e1355/src/BeI/Agent.cls#L114

## Something extra: running the watcher for cls

in the root directory

      npm install
      npm run watch


## Improvements to make

* Faster filter count speed
* Splitting source data from the filter so the product is easier usable in other projects
* boolean properties
