import React from 'react';
import { History } from 'react-router';
// -- React ToolBox
import AppBar from 'react-toolbox/lib/app_bar';
import Button from 'react-toolbox/lib/button';
import Navigation from 'react-toolbox/lib/navigation';
import Link from 'react-toolbox/lib/link';
import { List, ListItem, ListDivider } from 'react-toolbox/lib/list';
// -- Modules
import options from './modules/navigation'
// -- Style
import style from './menu.scss';

const Menu = React.createClass({

  mixins: [History],

  renderListItems () {
     return Object.keys(options).map((key) => {
      const option = options[key];
      const to = this.context.history.createHref(option.to);
      let className = style.item;
      if (this.context.history.isActive(option.to)) {
        className += ` ${style.active}`;
      }

      return (
        <ListItem
          key={key}
          caption={option.caption}
          className={className}
          leftIcon={option.icon}
          selectable
          to={to}
        />
      );
    });
  },

  render () {
    return (
      <aside className={style.root}>
        <AppBar fixed flat>
          <a href="/home">80 Cents</a>
          <Navigation>
            <a href="/home">80 Cents</a>
            <Link href="/#/components/link" label="Work" count={4} icon='business' />
            <Link href="/#/components/link" label="Blog" icon='speaker_notes' />
            <Link href="/#/components/link" label="Explore" icon='explore' />
          </Navigation>
          <Button icon='add' floating />
          <Button icon='add' floating accent mini />
        </AppBar>

        <header className={style.header}>
          <strong>80Cents</strong>
        </header>
        <List className={style.list} selectable ripple>
          { this.renderListItems() }
          <ListDivider />
          <ListItem caption='My Settings' />
        </List>
        <footer className={style.footer}>
          <span>80Cents © 2016</span>
        </footer>
      </aside>
    );
  }
});

export default Menu;
