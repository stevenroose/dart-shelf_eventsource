# shelf_eventsource

A shelf extension for EventSource or Server-Side Events (SSE) that works together with the 
[eventsource](https://pub.dartlang.org/packages/eventsource) package.


# How to use it?

The usage is really easy:
```dart
import "package:shelf/shelf_io.dart" as io;
import "package:eventsource/publisher.dart";
import "package:shelf_eventsource/shelf_eventsource.dart";

EventSourcePublisher publisher = new EventSourcePublisher(cacheCapacity: 100);
var handler = eventSourceHandler(publisher);
io.serve(handler, "localhost", 8080);
```
 
For a more extensive example with routing, see the `example/` directory.

## Licensing

This project is available under the MIT license, as can be found in the LICENSE file.