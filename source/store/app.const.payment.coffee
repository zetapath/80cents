"use strict"

__.const.payment = [
  value: 1, label: "Credit Card"
,
  value: 2, label: "Paypal"
,
  value: 3, label: "Bank Transfer"
]

__.const.ORDER =
  STATE:
    SHOPPING  : 0
    PURCHASED : 1
    PROCESSED : 2
    SENT      : 3
    FINISHED  : 4
