import React from 'react';
import ReactDOM from 'react-dom';
import { Router, Route, IndexRoute } from 'react-router';
import { createHashHistory } from 'history';
// -- Toolbox
import ReactToolboxApp from 'react-toolbox/lib/app';
// -- Components
import Main from './components/main';

ReactDOM.render((
  <Router history={createHashHistory({queryKey: false})}>
    <Route component={ReactToolboxApp}>
      <Route path="/" component={Main} />
      <Route path="/:context" component={Main}>
        <Route path=":component" />
      </Route>
      <IndexRoute component={Main} content='dashboard'/>
    </Route>
  </Router>
), document.getElementById('app'));
