# QueueProcessor

QueueProcessor built for test purposes. It has the following features:

1. Exposes an HTTP endpoint at the path `/receive-message` which accepts a GET
request with the query string parameters queue (string) message (string).
2. Accepts messages as quickly as they come in and return a 200 status code.
3. "process" the messages by printing the message text to the terminal, however
for each queue, only "processes" one message a second, no matter how quickly
the messages are submitted to the HTTP endpoint.


## Setup

```sh
# Install dependencies
$ mix deps.get
# Start Phoenix endpoint
$ mix phx.server
# Make a request to create a queue and process the message
$ curl -v http://localhost:4000/receive-message?queue=queue&message=message
# To stress the server by 10k requests with a concurrency factor of 32
$ mix stress
```
