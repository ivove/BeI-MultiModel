import React, { useState, useEffect } from 'react';
import './App.css';
import { Header } from "./components/Header";
import { Product } from "./components/Product";
import { Filter } from "./components/Filter";
//import {products, filters} from "./mocks";
import { IFilter, IProduct } from './types';
import {/*doesProductNameContain,*/changeFilterOptionChecked} from "./utils";
import { Helmet } from 'react-helmet-async';

function App() {
  const [state,updateState] = useState({products:Array<IProduct>(), searchTerm:"", filters: Array<IFilter>()});
  function onSearch(searchTerm : string) {
    /*
    const newProducts: IProduct[] = products.filter((product) =>
              doesProductNameContain(product,searchTerm))
    */
    const newSearchTerm=searchTerm;
    console.log(newSearchTerm);
    updateState({...state, searchTerm:newSearchTerm});
    console.log(state.searchTerm);
    updateProducts();
  }

  function filterCallBack(name:string, checked: boolean) {
    const newFilters: IFilter[]= state.filters;
    changeFilterOptionChecked(newFilters,name,checked);
    updateState({...state, filters:newFilters});
    updateProducts();
  }

  function updateProducts() {
    let payload = {
      "filters":state.filters,
      "sort": "price",
      "pageSize": 10,
      "lastId": 0,
      "searchTerm": state.searchTerm
    };
    console.log(payload);

    fetch("http://localhost:9092/BeI/products", {
      method: 'POST', // *GET, POST, PUT, DELETE, etc.
      mode: 'cors', // no-cors, *cors, same-origin
      cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
      credentials: 'same-origin', // include, *same-origin, omit
      headers: {
        'Content-Type': 'application/json'
        // 'Content-Type': 'application/x-www-form-urlencoded',
      },
      redirect: 'follow', 
      referrerPolicy: 'no-referrer',
      body: JSON.stringify(payload)}
    ).then(res => res.json())
    .then(
      (result) => {
        console.log(result);
        updateState({...state,products: result.products})
      },
      // Note: it's important to handle errors here
      // instead of a catch() block so that we don't swallow
      // exceptions from actual bugs in components.
      (error) => {
  
      }
    );
  }

  useEffect(() => {
    // code to run on component mount
    fetch("http://localhost:9092/BeI/filters/1")
    .then(res => res.json())
    .then(
      (result) => {
        console.log(result.filters);
        updateState(prevState => {
          return {...prevState, filters: result.filters}});
      },
      // Note: it's important to handle errors here
      // instead of a catch() block so that we don't swallow
      // exceptions from actual bugs in components.
      (error) => {
  
      }
    );
  }, [])

return (
<div className="App">
  <Helmet>
    <meta charSet="utf-8" />
    <title>React app</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet"
      integrity="sha384-giJF6kkoqNQ00vy+HMDP7azOuL0xtbfIcaT9wjKHr8RbDVddVHyTfAAsrekwKmP1" crossOrigin="anonymous">
    </link>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/js/bootstrap.bundle.min.js"
      integrity="sha384-ygbV9kiqUc6oa4msXn9868pTtWMgiQaeYH7/t7LECLbyPA2x65Kgf80OJFdroafW" crossOrigin="anonymous">
    </script>
  </Helmet>
  <Header searchCallback={onSearch}/>
  <div className="container--xxl .mt-2 px-4">
    <div className="row">
      <div className="col-sm-3 border px-4">
        {state.filters.map(
            (filter) => (
              <Filter key={filter.id} filter={filter} filterCallBack={filterCallBack} />
            )
          )}        
      </div>
      <div className="col-sm-9 border">
        <div className="row row-cols-3 px-4">
          {state.products.map(
            (product) => (
              <Product key={product.id} product={product} />
            )
          )}
        </div>
      </div>
    </div>
  </div>
  </div>
);
}

export default App;