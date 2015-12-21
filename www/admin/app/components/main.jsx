import React from 'react';
// -- Toolbox
import {Button, IconButton} from 'react-toolbox/lib/button';
// -- Components
import Menu from './menu'
// -- Style
import style from '../index.scss';

class Main extends React.Component {

  render () {
    return (
      <div>
        <Menu />
        <section>
          content
        </section>
      </div>
    );
  }
}
export default Main;
