"use strict"

__.scaffold.form_product =
  endpoint: "product"
  entity_name: "Product"
  children: [
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Product Details"
    ,
      "Atom.Text": value: "Write a name and description, and provide a type and vendor to categorize this product."
    ]
  ,
    "Molecule.Form": children: [
      "Atom.Input": name: "id", style: "hidden"
    ,
      "Atom.Label": value: "Title"
    ,
      "Atom.Input": name: "title", placeholder: "e.g. Unicorn crest short sleeve tee", required: true, events: ["keyup"]
    ,
      "Atom.Label": value: "Description"
    ,
      "Atom.Wysihtml5": name: "description", id: "product", required: true, events: ["keyup"]
    ,
      "Atom.Label": style: "half", value: "Type"
    ,
      "Atom.Label": style: "half", value: "Vendor"
    ,
      "Atom.Input": style: "half", name: "type", placeholder: "e.g. Bicycles, T-Shirts", required: true, events: ["keyup"]
    ,
      "Atom.Input": style: "half", name: "vendor", placeholder: "e.g. Apple, Shopify"
    ]
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Inventory & variants"
    ,
      "Atom.Text": value: "Configure the options for selling this product."
    ]
  ,
    "Molecule.Form": children: [
      "Atom.Label": style: "quarter", value: "Price"
    ,
      "Atom.Label": style: "quarter", value: "Compare at price"
    ,
      "Atom.Label": style: "quarter", value: "SKU"
    ,
      "Atom.Label": style: "quarter", value: "Barcode"
    ,
      "Atom.Input": style: "quarter", name: "price", placeholder: "0.00", required: true, events: ["keyup"]
    ,
      "Atom.Input": style: "quarter", name: "compare_at_price", placeholder: "0.00"

    ,
      "Atom.Input": style: "quarter", name: "stock", placeholder: "Stock Keeping Unit"
    ,
      "Atom.Input": style: "quarter margin-bottom", name: "barcode", placeholder: "e.g. UPC, ISBN"
    # -- Variants
    ,
      "Atom.Label": style: "quarter", value: "Weight"
    ,
      "Atom.Label": style: "quarter", value: "Sizes"
    ,
      "Atom.Label": style: "quarter", value: "Colors"
    ,
      "Atom.Label": style: "quarter", value: "Materials"
    ,
      "Atom.Input": style: "quarter", name: "weight", placeholder: "0.0"
    ,
      "Atom.Input": style: "quarter", name: "sizes", placeholder: "e.g. S, L, XL.."
    ,
      "Atom.Input": style: "quarter", name: "colors", placeholder: "e.g. blue, green"
    ,
      "Atom.Input": style: "quarter margin-bottom", name: "materials", placeholder: "e.g. nylon, cotton"
    ,
      "Atom.Input": type: "checkbox", name: "tax"
    ,
      "Atom.Label": value: "Charge taxes on this product"
    ,
      "Atom.Input": type: "checkbox", name: "requires_shipping"
    ,
      "Atom.Label": value: "Requires shipping (not needed for services or digital goods)"
    ]
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Images"
    ,
      "Atom.Text": value: "Upload and edit images of this product. Drag to reorder images."
    ]
  ,
    "Molecule.Images": id: "images"
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Collections"
    ,
      "Atom.Text": value: "Collections can be used to group products together."
    ]
  ,
    "Molecule.Form": id: "collection", children: [
      "Atom.Label": value: "Available collections"
    ,
      "Atom.Select": id: "id", name: "collection_id", options: []
    ]
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Tags"
    ,
      "Atom.Text": value: "Tags can be used to categorize products by properties like color, size, and material."
    ]
  ,
    "Molecule.Form": children: [
      "Atom.Label": value: "Tags"
    ,
      "Atom.Input": name: "tags", placeholder: "vintage, cotton, summer"
    ]
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Search engines"
    ,
      "Atom.Text": value: "Set up the page title, meta description and handle. These help define how this product shows up on search engines."
    ]
  ,
    "Molecule.SearchEngine": id: "search"
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Div": children: [
      "Atom.Heading": size: "h2", value: "Visibility"
    ,
      "Atom.Text": value: "Control whether this product can be seen."
    ]
  ,
    "Molecule.Form": children: [
      "Atom.Label": value: "Visible"
    ,
      "Atom.Switch": name: "visibility"
    ,
      "Atom.Label": value: "Highlight in Home Page"
    ,
      "Atom.Switch": name: "highlight"
    ]
  ,
    "Atom.Label": style: "anchor"
  ,
    "Molecule.Navigation": children: [
      "Atom.Button": style: "cancel", text: "Remove", callbacks: ["onRemove"], disabled: true
    ,
      "Atom.Button": style: "theme", text: "Save", callbacks: ["onSave"]
    ]
  ]
