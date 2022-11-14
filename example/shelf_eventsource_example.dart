import "dart:async";

import "package:shelf/shelf_io.dart" as io;
import "package:shelf_router/shelf_router.dart" as routing;

import "package:eventsource/publisher.dart";
import "package:shelf_eventsource/shelf_eventsource.dart";

main() {
  // create the publisher object that will manage event publishing to
  // subscribers
  EventSourcePublisher publisher = EventSourcePublisher(cacheCapacity: 100);

  // generate some dummy events
  generateEvents(publisher);

  // create a shelf handler
  var handler = eventSourceHandler(publisher);
  // or create a handler for a specific channel
  var channelHandler =
      eventSourceHandler(publisher, channel: "mychannel", gzip: true);

  // create a router to serve the different event sources
  var router = routing.Router();
  router.get("/events", handler);
  router.get("/mychannel", channelHandler);

  // serve localhost with our router
  io.serve(router, "localhost", 8080);
}

generateEvents(publisher) {
  int id = 0;
  Timer.periodic(const Duration(seconds: 1), (timer) {
    // publish an event on the default channel
    publisher.add(Event.message(id: "$id", data: "Always the same message?"));
    // publish event in a channel
    publisher.add(
        Event.message(id: "$id", data: "Mychannel Message"), ["mychannel"]);
    if (id == 25) {
      timer.cancel();
      // broadcast last message to both channels and close them
      publisher.add(
          Event(event: "goodbye", data: "Goodbye all!"), ["", "mychannel"]);
      publisher.closeAll();
    }
  });
}
