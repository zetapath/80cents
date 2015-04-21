"use strict"

class Atoms.Atom.Review extends Atoms.Atom.Li

  @template = """
    <li>
      <figure></figure>
      <div>
        <small>{{#if.user}}<strong>{{user}}</strong><span> - </span>{{/if.user}}<span>{{when}}</span></small>
        {{#if.title}}<strong>{{title}}</strong>{{/if.title}}
        <p>{{description}}</p>
      </div>
    </li>
    """
