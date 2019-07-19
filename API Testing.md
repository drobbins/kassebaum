# Kassebaum API Testing

The Kassebaum API is accessible via routes in **server/rest-api.js**. API routes all begin with the URL of a kassebaum server and the prefix **/api/1.0**. For local development, this is:

```
http://localhost:3000/api/1.0
```

All routes documented below are based on this prefix.

### API Tokens

All API requests require a token. These are managed in the Kassebaum App in the Admin section. Tokens are passed as a query parameter:

```
http://localhost:3000/api/1.0/hello?token=abc123
```

## /hello

This is a test route for API tokens. Using a valid token will return a message, missing or revoked tokens will return `401`.

## /dev/reloadfixtures

`/dev` routes are not accessible in production.

Reloads development fixtures. This will remove all patients in the database and load three test patients, returning the development database to a known state.

## /patients

Add or update patients via HTTP POST with JSON body. Works similarly to adding patients via the web app, using the following algorithm:

```
                      ┌──────────────────────────────────────────────────────────┐
                      │         _      _    _   ___      _   _         _         │
                      │        /_\  __| |__| | | _ \__ _| |_(_)___ _ _| |_       │
                      │       / _ \/ _` / _` | |  _/ _` |  _| / -_) ' \  _|      │
                      │      /_/ \_\__,_\__,_| |_| \__,_|\__|_\___|_||_\__|      │
                      │                                                          │
                      └──────────────────────────────────────────────────────────┘
                                                    │
                                                    ▼
                                    ┌──────────────────────────────┐
                                    │  Look for existing patient   │
                                    │ based on provided MRN field. │
                                    └──────────────────────────────┘
                                                    │
               ┌────────────────────────────────────┼───────────────────────────────┐
               │                                    │                               │
               ▼                                    ▼                               ▼

 Patient with MRN = MRN Found       Patient with MRN = ShortID Found        No Patient Found

               │                                    │                               │
               │                                    │                               │
               └────────────────┬───────────────────┘                               │
                                │                                                   │
                                ▼                                                   ▼
                ┌──────────────────────────────┐                    ┌──────────────────────────────┐
                │    Merge existing and new    │                    │  Create new Patient Record   │
                │   Instances of Procurement   │                    │                              │
                └──────────────────────────────┘                    └──────────────────────────────┘
                                │                                                   │
                                │                                                   │
                                └───────────────────┬───────────────────────────────┘
                                                    │
                                                    │
                                                    ▼
                                    ┌──────────────────────────────┐
                                    │        Return ShortID        │
                                    │                              │
                                    └──────────────────────────────┘
```

### Sample Data

Success or errors below are based on a fresh development database, e.g. after using `/dev/reloadfixtures`. All data should be sent as a JSON body of an HTTP POST request with a valid token.

#### One Patient - Success

Request
```js
{
  "firstName": "Julienne",
  "lastName": "Hsistest",
  "mrn": "1029384756",
  "instancesOfProcurement": [
    {
      "surgicalPathologyNumber": "0192837465",
      "date": 1555990148412,
      "otherNumber": ""
    },
    {
      "otherNumber": "0912873456",
      "date": 1555903748412,
      "surgicalPathologyNumber": ""
    }
  ],
  "dateOfBirth": 1001048400000,
  "externalMrn": false,
  "middleName": ""
}
```

Expected Response
```js
[
  {
    "status": "success",
    "shortId": "O2Y69H",	// Generated ShortID
    "original": {...}	 	// Same as request body.
  }
]
```


#### One Patient - Failure

This request is missing required fields, leading to an error.

Request
```js
{
  "mrn": "1029384756",
  "instancesOfProcurement": [
    {
      "surgicalPathologyNumber": "0192837465",
      "date": 1555990148412,
      "otherNumber": ""
    },
    {
      "otherNumber": "0912873456",
      "date": 1555903748412,
      "surgicalPathologyNumber": ""
    }
  ],
  "dateOfBirth": 1001048400000,
  "externalMrn": false,
  "middleName": ""
}
```

Expected Result
```js
[
  {
    "status": "error",	// Error status
    "error": {			// Content of error
      "isClientSafe": true,
      "error": 422,
      "reason": "Patient first name, last name, and MRN are required",
      "message": "Patient first name, last name, and MRN are required [422]",
      "errorType": "Meteor.Error"
    },
    "original": {...}	// Same as request body.
]
```

### Multiple Patients - Success

Request
```js
[
  {
    "mrn": "EFdsdw",
    "instancesOfProcurement": [
      {
        "otherNumber": "",
        "date": 1563543482910,
        "surgicalPathologyNumber": "0912873456"
      }
    ]
  },
  {
    "mrn": "1234567891",
    "instancesOfProcurement": [
      {
        "otherNumber": "",
        "date": 1563543482910,
        "surgicalPathologyNumber": "0912873456"
      }
    ]
  },
  {
    "firstName": "Barbra",
    "lastName": "Hsistest",
    "middleName": "Q",
    "dateOfBirth": 415432800000,
    "mrn": "YPK2RQ",
    "externalMrn": false,
    "instancesOfProcurement": [
      {
        "otherNumber": "",
        "date": 1563543482910,
        "surgicalPathologyNumber": "0912873456"
      }
    ]
  }
]
```

Expected Result
```js
[
  {
    "status": "success",
    "shortId": "EFdsdw",
    "original": {
      "mrn": "EFdsdw",
      "instancesOfProcurement": [
        {
          "otherNumber": "",
          "date": 1563543482910,
          "surgicalPathologyNumber": "0912873456"
        }
      ]
    }
  },
  {
    "status": "success",
    "shortId": "cbd1rC",
    "original": {
      "mrn": "1234567891",
      "instancesOfProcurement": [
        {
          "otherNumber": "",
          "date": 1563543482910,
          "surgicalPathologyNumber": "0912873456"
        }
      ]
    }
  },
  {
    "status": "success",
    "shortId": "CCRQHC",
    "original": {
      "firstName": "Barbra",
      "lastName": "Hsistest",
      "middleName": "Q",
      "dateOfBirth": 415432800000,
      "mrn": "YPK2RQ",
      "externalMrn": false,
      "instancesOfProcurement": [
        {
          "otherNumber": "",
          "date": 1563543482910,
          "surgicalPathologyNumber": "0912873456"
        }
      ],
      "added": 1563549629259,
      "shortId": "CCRQHC"
    }
  }
]
```

#### Multiple Patients - Failure

This request contains some documents that will succeed, and one that will fail due to missing fields.

Request
```js
[
  {
    "mrn": "EFdsdw",	// Update existing record by ShortID in MRN field
    "instancesOfProcurement": [
      {
        "otherNumber": "",
        "date": 1563543482910,
        "surgicalPathologyNumber": "0912873456"
      }
    ]
  },
  {
    "mrn": "1234567891",	// Update existing record by MRN
    "instancesOfProcurement": [
      {
        "otherNumber": "",
        "date": 1563543482910,
        "surgicalPathologyNumber": "0912873456"
      }
    ]
  },
  {
    "mrn": "YPK2RQ",	// New Record, missing fields. Should produce error.
    "externalMrn": false,
    "instancesOfProcurement": [
      {
        "otherNumber": "",
        "date": 1563543482910,
        "surgicalPathologyNumber": "0912873456"
      }
    ]
  }
]
```

Expected Response
```js
[
  {
    "status": "success",
    "shortId": "EFdsdw",
    "original": {
      "mrn": "EFdsdw",
      "instancesOfProcurement": [
        {
          "otherNumber": "",
          "date": 1563543482910,
          "surgicalPathologyNumber": "0912873456"
        }
      ]
    }
  },
  {
    "status": "success",
    "shortId": "cbd1rC",
    "original": {
      "mrn": "1234567891",
      "instancesOfProcurement": [
        {
          "otherNumber": "",
          "date": 1563543482910,
          "surgicalPathologyNumber": "0912873456"
        }
      ]
    }
  },
  {
    "status": "error",
    "error": {
      "isClientSafe": true,
      "error": 422,
      "reason": "Patient first name, last name, and MRN are required",
      "message": "Patient first name, last name, and MRN are required [422]",
      "errorType": "Meteor.Error"
    },
    "original": {
      "mrn": "YPK2RQ",
      "externalMrn": false,
      "instancesOfProcurement": [
        {
          "otherNumber": "",
          "date": 1563543482910,
          "surgicalPathologyNumber": "0912873456"
        }
      ]
    }
  }
]
```
