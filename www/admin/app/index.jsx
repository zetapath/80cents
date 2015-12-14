import React from 'react';
import ReactDOM from 'react-dom';
// -- Toolbox
import ReactToolboxApp from 'react-toolbox/lib/app';
import {Button, IconButton} from 'react-toolbox/lib/button';
// -- Components
import Navigation from './components/navigation'
// -- Style
import style from './index.scss';

ReactDOM.render((
  <ReactToolboxApp className={style.root}>
    <Navigation />
    <section>
      <Button icon='bookmark' label='Bookmark' accent />
      <Button icon='bookmark' label='Bookmark' raised primary />
      <Button icon='inbox' label='Inbox' flat />
      <Button icon='add' floating />
      <Button icon='add' floating accent mini />
      <IconButton icon='favorite' accent />
      <Button icon='add' label='Add this' flat primary />
      <Button icon='add' label='Add this' flat disabled />
    </section>
  </ReactToolboxApp>
), document.getElementById('app'));
