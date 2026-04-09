const googlePayConfig = '''{
  "provider": "google_pay",
  "data": {
    "environment": "TEST",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "example",
            "gatewayMerchantId": "gatewayMerchantId"
          }
        },
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "billingAddressRequired": true,
          "billingAddressParameters": {
            "format": "FULL",
            "phoneNumberRequired": true
          }
        }
      }
    ],
    "merchantInfo": {
      "merchantId": "BCR2DN4TRL3INJ2U",
      "merchantName": "Jobreels"
    },
    "transactionInfo": {
      "countryCode": "US",
      "currencyCode": "USD"
    }
  }
}''';

const applePayConfig = '''{
  "provider": "apple_pay",
  "data": {
    "merchantIdentifier": "merchant.com.job.jobreels",
    "displayName": "JobReels App",
    "merchantCapabilities": ["3DS", "debit", "credit"],
    "supportedNetworks": ["amex", "visa", "discover", "masterCard"],
    "countryCode": "US",
    "currencyCode": "USD",
    "requiredBillingContactFields": ["emailAddress", "name", "phoneNumber", "postalAddress"],
    "requiredShippingContactFields": [],
    "shippingMethods": [
    {
      "amount": "0.00",
      "detail": "Available within an hour",
      "identifier": "in_store_pickup",
      "label": "In-Store Pickup"
    },
    {
      "amount": "4.99",
      "detail": "5-8 Business Days",
      "identifier": "flat_rate_shipping_id_2",
      "label": "UPS Ground"
    },
    {
      "amount": "29.99",
      "detail": "1-3 Business Days",
      "identifier": "flat_rate_shipping_id_1",
      "label": "FedEx Priority Mail"
    }
    ]
  }
}''';