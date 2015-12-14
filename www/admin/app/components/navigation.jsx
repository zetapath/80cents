import React from 'react';
import { History } from 'react-router';
import { List, ListItem } from 'react-toolbox/lib/list';
// -- Style
import style from './navigation.scss';

const Navigation = React.createClass({

  mixins: [History],

  render () {
    return (
      <aside className={style.root}>
        <header className={style.header}>
          <strong>80Cents</strong>
        </header>
        <List className={style.list} selectable ripple>
        </List>
        <footer className={style.footer}>
          <span>80Cents © 2016</span>
        </footer>
      </aside>
    );
  }
});

export default Navigation;
