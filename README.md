## High-level description

Reshorten is a service for: _Developers who need to shorten URLs and gather stats on 
how many time short-URLs has been used_.

The service will consist in a Public Http (content-type JSON) API.

1. Endpoints scoped under `/api/links` (CRUD operations on short links).
2. Single Endpoint (`/:short_code`) to serve short urls (which simply redirects you to the original URL).

## Usage

The following demonstration is done using [httpie](https://httpie.org/) but feel free to use your favourite http client (browser, postman etc...). 

**Start the service in a terminal:**

```
$ rails s
```

**From another terminal (or from any http client):**

```
$ http POST :3000/api/links url=https://www.returnista.nl/

HTTP/1.1 201 Created
...
{
  "data": {
     ...
     "short_code": "gK1Btc",
     "redirect_count": 0
     ...
  }
}
```

**To make use of the short link:** 

Type the following url in your browser replacing `<short_code>` appropriately: 
`http://localhost:3000/<short_code>`. You will be redirected to the original URL.

**To see statistics for this freshly generated shortcode:**

```
$ http GET :3000/api/links/<short_code>

HTTP/1.1 200 OK
...

{
  "data": {
    ...
    "redirect_count": 1,
    ...
  }
}
```  

You should see `redirect_count` incremented.


You can also checkout the other endpoint described bellow.


## Details - Links CRUD operations

Specification of the WEB JSON API layer to create, show, update, delete a link.

### POST /api/links

#### Request
```javascript
POST /api/links
Content-Type: "application/json"

{
  "url": "http://stage.example.com"
}
```

#### Response

```javascript
201 Created
Content-Type: "application/json"

{
  "data": {
    "short_code": "J0c_kq",
    "url": "http://example.com",
    "redirect_count": 0
  }
}
```

#### Errors

```javascript
422 Unprocessable Entity
Content-Type: "application/json"

{
  "errors": {
    "url": "Validation failed: Url is invalid"
    }
}
```

### GET /api/:short_code
#### Request

```javascript
GET /api/:short_code
Content-Type: "application/json"
```

#### Response

```javascript
200 Ok
Content-Type: "application/json"

{
  "data": {
     "short_code": "short_", 
      "url": "http://example.com",
      "createdAt": "2018-10-01T10:30:00Z",
      "lastSeenAt": "2018-10-23T11:31:00Z",
      "redirectCount": 442
  }
}
```

#### Errors

* 404 - `Couldn't find Link`

### PUT /api/links/:short_code/

#### Request
```javascript
PUT  /api/:short_code
Content-Type: "application/json"

{
  "url": "http://example.com"
}
```

#### Response

```javascript
204 No Content
Content-Type: "application/json"
```

#### Errors

* 404 - `Couldn't find Link`
* 422 - `Validation failed: Url is invalid`

### DELETE /api/links/:short_code/

#### Request
```javascript
DELETE  /api/:short_code
Content-Type: "application/json"
```

#### Response

```javascript
204 No Content
Content-Type: "application/json"
```

#### Errors

* 404 - `Couldn't find Link`


## Details - URL redirection

Specification of the redirection API.


### Short link redirection - GET /:short_code

#### Request
```javascript
GET /:short_code
Content-Type: "application/json"
```

#### Response

```javascript
HTTP/1.1 302 Found
Location: http://www.example.com
```

#### Errors

* 404 - `Couldn't find Link`


## Note/Todo

Let's use SQLite to persist tracked URLs for now. But as we scale and 
our security requirements raises SQLite won't be enough. 
Because our service will be sitting between users and the actual content, 
we want things to go fast when they hit short URLs, therefore, using an 
in-memory storage to keep track of URLs would help (e.g Redis with long-term 
persistence strategy to be defined).

WARNING: Special care should be taken when updating redirection count (**3.**). 
Due to the expected high reads rate, we are very likely to meet race 
conditions. We should seek for atomic updates.

* Documentation
* Links Service (#4)
* Retry Link creation on duplicate :short_code (#11)
* [Project Board](https://github.com/KiyoMenager/reshorten/projects/2) 