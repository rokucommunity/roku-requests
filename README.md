# roku-requests
Simple, python requests inspired Brightscript requests framework for Roku apps

[![build status](https://img.shields.io/github/workflow/status/rokucommunity/roku-requests/build.svg?logo=github)](https://github.com/rokucommunity/roku-requests/actions?query=workflow%3Abuild)
[![monthly downloads](https://img.shields.io/npm/dm/roku-requests.svg?sanitize=true&logo=npm&logoColor=)](https://npmcharts.com/compare/roku-requests?minimal=true)
[![npm version](https://img.shields.io/npm/v/roku-requests.svg?logo=npm)](https://www.npmjs.com/package/roku-requests)
[![license](https://img.shields.io/github/license/rokucommunity/roku-requests.svg)](LICENSE)
[![Slack](https://img.shields.io/badge/Slack-RokuCommunity-4A154B?logo=slack)](https://join.slack.com/t/rokudevelopers/shared_invite/zt-4vw7rg6v-NH46oY7hTktpRIBM_zGvwA)

## Installation
### Using ropm
```bash
ropm install roku-requests
```
### Manually
Copy `src/source/Requests.brs` into your project as `source/Requests.brs` folder

## Usage

### Make a Request

Making a request with Requests is very simple.
```
Brightscript Debugger> r = Requests().get("https://api.github.com/events")
```

Now, we have a Response object called r. We can get all the information we need from this object.

```
Brightscript Debugger> ?r.ok
Brightscript Debugger> true
Brightscript Debugger> ?r.statuscode
Brightscript Debugger>  200
```

Requests’ simple API means that all forms of HTTP request are as obvious. For example, this is how you make an HTTP POST request:

```
Brightscript Debugger> r = Requests().post("https://httpbin.org/post", {"data":"value"})
```

What about the other HTTP request types: PUT, DELETE, HEAD and OPTIONS? These are all supported and simple by using the `.request(VERB...` method:

```
Brightscript Debugger> r = Requests().request("PUT", "https://httpbin.org/put", {"key":"value"})
Brightscript Debugger> r = Requests().request("DELETE", "https://httpbin.org/delete", {})
Brightscript Debugger> r = Requests().request("HEAD", "https://httpbin.org/get", {})
Brightscript Debugger> r = Requests().request("OPTIONS", "https://httpbin.org/get", {})
```

### Passing Parameters In URLs

```
Brightscript Debugger> payload = {"key1": "value1", "key2": "value2"}
Brightscript Debugger> r = Requests().get("https://httpbin.org/get", {"params":payload})
```

You can see that the URL has been correctly encoded by printing the URL:

```
Brightscript Debugger> ?r.url
Brightscript Debugger> https://httpbin.org/get?key1=value1&key2=value2
```

### Response Content

We can read the content of the server’s response. Consider the GitHub timeline again:

```
Brightscript Debugger> r = Requests().get("https://api.github.com/events")`
Brightscript Debugger> ?r.text
Brightscript Debugger> [{"id":"8575373301","type":"WatchEvent","actor":{"id":4537355,"login":"...
```

### JSON Response Content

There’s also a builtin JSON encoder/decoder, in case you’re dealing with JSON data:
```
Brightscript Debugger> r = Requests().get("https://api.github.com/events")
Brightscript Debugger> ?r.json
Brightscript Debugger> <Component: roArray> =
[
    <Component: roAssociativeArray>
    <Component: roAssociativeArray>
    ...
]
```

You also also pass flags for json parsing. `parseJsonFlags` is passed to the [ParseJson()](https://developer.roku.com/en-ca/docs/references/brightscript/language/global-utility-functions.md#parsejsonjsonstring-as-string-flags---as-string-as-object) function.
```
Brightscript Debugger> r = Requests().get("https://api.github.com/events", {parseJsonFlags:"i"})
Brightscript Debugger> ?r.json
```
Or disable json parsing
```
Brightscript Debugger> r = Requests().get("https://api.github.com/events", {parseJson:false})
Brightscript Debugger> ?r.json
```
### Custom Headers

If you’d like to add HTTP headers to a request, simply pass in an `AA` to the `headers` key in the args dictionary.

```
Brightscript Debugger> url =
Brightscript Debugger> headers = {"user-agent": "my-app/0.0.1"}
Brightscript Debugger> r = Requests().get(url, {"headers":headers})
```

### More complicated POST requests

Instead of encoding the `AA` yourself, you can also pass it directly using the `json` parameter
```
Brightscript Debugger> url = "https://httpbin.org/post"
Brightscript Debugger> payload = {"some": "data"}
Brightscript Debugger> r = Requests().post(url, {"json":payload})
```

Using the `json` parameter in the request will change the `Content-Type` in the header to `application/json`.


### Response Status Codes

```
Brightscript Debugger> r = Requests().get("https://httpbin.org/get")
Brightscript Debugger> ?r.statuscode
Brightscript Debugger>  200
```

### Response Headers

We can view the server’s response headers using an AA:
```
Brightscript Debugger> ?r.headers
Brightscript Debugger> <Component: roAssociativeArray> =
{
    access-control-allow-credentials: "true"
    access-control-allow-origin: "*"
    connection: "keep-alive"
    content-length: "272"
    content-type: "application/json"
    date: "Mon, 12 Nov 2018 17:25:53 GMT"
    server: "gunicorn/19.9.0"
    via: "1.1 vegur"
}
```

### Timeouts

You can tell Requests to stop waiting for a response after a given number of seconds with the `timeout` parameter (int).
```
Brightscript Debugger> r = Requests().get("https://httpbin.org/delay/10", {"timeout":1})
Brightscript Debugger> <Component: roAssociativeArray> =
{
    cachehit: false
    ok: false
    timestried: 1
    url: "https://httpbin.org/delay/10"
}
```

### Caching

You can tell Requests to use cache (on by default) by passing the `useCache` parameter (boolean). This will automatically cache the request if there are `cache-control` headers in the response.
```
Brightscript Debugger> r = Requests().get("https://httpbin.org/cache/60", {"useCache":true})
```

You can see if the cache was hit by checking the `cacheHit` value on the Response object.
```
Brightscript Debugger> r = Requests().get("https://httpbin.org/cache/60", {"useCache":true})
Brightscript Debugger> ?r.cachehit
Brightscript Debugger> false
Brightscript Debugger> r = Requests().get("https://httpbin.org/cache/60", {"useCache":true})
Brightscript Debugger> ?r.cachehit
Brightscript Debugger> true
```

If the server does not return `cache-control` headers or you want to manually specify the time to cache a request just pass the `cacheSeconds` parameter (int) to Requests.
```
Brightscript Debugger> r = Requests().get("https://httpbin.org/get", {"useCache":true, "cacheSeconds":300})
```

#### Notes about Cache implementation

Roku's Cachefs:
* The cache implementation uses Roku's `cachefs` (https://sdkdocs.roku.com/display/sdkdoc/File+System)
* `cachefs` is available as a Beta feature starting in Roku OS 8.
* `cachefs` exists across channel launches but will evict data when more space is required for another Channel.

Cache Keys and Storage Location
* Requests uses an MD5 hash of the URL + Request Headers being passed as the cache key
* Requests stores the cached request as a file in `cachefs:/{MD5_HASH}`. Please be aware of this if your channel is storing things in the `cachefs:/` space as there is a very minute possiibility of name collisions.
* The cache data is stored as a file with the first line as a unix epoch of the time the file was written (time the first request was made).  Subsequient requests read the file and compute/compare timestamps to determine if the cached file is still valid or not.


## Development

Roku Requests is an independent open-source project, maintained exclusively by volunteers.

You might want to help! Get in touch via the slack group, or raise issues.
