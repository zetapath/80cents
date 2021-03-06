"use strict"

__.scaffold.form_settings =
  endpoint: "settings"
  entity_name: "Settings"
  children: [
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Settings details"
    ,
      "Atom.Text": value: "Edit your store information. The store name shows up on your storefront, while the title and meta description help define how your store shows up on search engines."
    ]
  ,
    "Molecule.Form": children: [
      "Atom.Input": name: "id", style: "hidden"
    ,
      "Atom.Label": value: "Name"
    ,
      "Atom.Input": name: "name", required: true
    ,
      "Atom.Label": value: "Homepage title (70 characters max)"
    ,
      "Atom.Input": name: "title", placeholder: "", required: true
    ,
      "Atom.Label": value: "Homepage meta description"
    ,
      "Atom.Textarea": style: "margin-bottom anchor", name: "description", placeholder: "Enter a description to avoid ranking poorly on search engines like Google."
    ,
      "Atom.Label": style: "half", value: "Account email"
    ,
      "Atom.Label": style: "half", value: "Customer email"
    ,
      "Atom.Input": style: "half", name: "account_mail", required: true, events: ["keyup"]
    ,
      "Atom.Input": style: "half", name: "customer_mail"
    ,
      "Atom.Label": style: "half tip", value: "Email used for Shopio to contact you about your account"
    ,
      "Atom.Label": style: "half tip", value: "Your customers will see this when you email them (e.g.: order confirmations)"
    ]
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Store address"
    ,
      "Atom.Text": value: "This address will appear on your invoices and will be used to calculate your shipping rates."
    ]
  ,
    "Molecule.Address": id: "address", title: "Legal Name of Business"
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Social Networks"
    ,
      "Atom.Text": value: "Set you social networks links."
    ]
  ,
    "Molecule.Networks": id: "networks"
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Standards & formats"
    ,
      "Atom.Text": value: "Standards and formats are used to calculate such things as product price, shipping weight and the time an order was placed."
    ]
  ,
    "Molecule.Form": children: [
      "Atom.Label": value: "Language"
    ,
      "Atom.Input": name: "language"
    ,
      "Atom.Label": style: "half", value: "Timezone"
    ,
      "Atom.Label": style: "half", value: "Currency"
    ,
      "Atom.Select": style: "half", name: "timezone", options: __.const.timezone
    ,
      "Atom.Select": style: "half", name: "currency", options: __.const.currency
    ,
      "Atom.Label": style: "half", value: "Unit system"
    ,
      "Atom.Label": style: "half", value: "Weight Unit"
    ,
      "Atom.Select": style: "half", name: "unit_system", options: __.const.unit_system
    ,
      "Atom.Select": style: "half", name: "weight_unit", options: __.const.weight_unit
    ]
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Google Analytics"
    ,
      "Atom.Text": value: "Google Analytics enables you to track the visitors to your store, and generates reports that will help you with your marketing."
    ]
  ,
    "Molecule.Form": children: [
      "Atom.Label": value: "Google Analytics account"
    ,
      "Atom.Textarea": name: "google_analytics", placeholder: "Paste your code from Google Here", style: "code"
    ]
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Navigation": children: [
      "Atom.Button": style: "theme", text: "Save", callbacks: ["onSave"]
    ]
  ]
