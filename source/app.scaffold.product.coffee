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
      "Atom.Input": name: "title", placeholder: "e.g. Unicorn crest short sleeve tee", required: true
    ,
      "Atom.Label": value: "Description"
    ,
      "Atom.Textarea": name: "description"
    ,
      "Atom.Label": style: "half", value: "Type"
    ,
      "Atom.Label": style: "half", value: "Vendor"
    ,
      "Atom.Input": style: "half", name: "type", placeholder: "e.g. Bicycles, T-Shirts"
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
      "Atom.Label": style: "half", value: "Price"
    ,
      "Atom.Label": style: "half", value: "Compare at price"
    ,
      "Atom.Input": style: "half", name: "price", placeholder: "0.00"
    ,
      "Atom.Input": style: "half", name: "compare_at_price", placeholder: "0.00"
    ,
      "Atom.Label": style: "half", value: "SKU"
    ,
      "Atom.Label": style: "half", value: "Barcode"
    ,
      "Atom.Input": style: "half margin-bottom", name: "stock", placeholder: "Stock Keeping Unit"
    ,
      "Atom.Input": style: "half", name: "barcode", placeholder: "e.g. UPC, ISBN"
    ,
      "Atom.Input": type: "checkbox", name: "tax"
    ,
      "Atom.Label": value: "Charge taxes on this product"
    ,
      "Atom.Input": type: "checkbox", name: "requires_shipping"
    ,
      "Atom.Label": style: "margin-bottom", value: "Requires shipping (not needed for services or digital goods)"
    # -- Variants
    ,
      "Atom.Label": style: "half", value: "Weight"
    ,
      "Atom.Label": style: "half", value: "Sizes"
    ,
      "Atom.Input": style: "half", name: "weight", placeholder: "0.0"
    ,
      "Atom.Input": style: "half", name: "sizes", placeholder: "e.g. S, L, XL.."
    ,
      "Atom.Label": style: "half", value: "Colors"
    ,
      "Atom.Label": style: "half", value: "Materials"
    ,
      "Atom.Input": style: "half", name: "colors", placeholder: "e.g. blue, green"
    ,
      "Atom.Input": style: "half", name: "materials", placeholder: "e.g. nylon, cotton"
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
    "Molecule.Form": children: [
      "Atom.Label": value: "Page title"
    ,
      "Atom.Input": name: "page_title", placeholder: "less than 70 characters", maxlength: 70
    ,
      "Atom.Label": value: "Meta Description"
    ,
      "Atom.Textarea": name: "meta_description", placeholder: "less than 160 characters", maxlength: 160
    ,
      "Atom.Label": value: "URL & Handle"
    ,
      "Atom.Input": name: "url_handle", placeholder: "/products/"
    ]
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
