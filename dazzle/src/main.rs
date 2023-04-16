use tracing_subscriber::fmt::format::FmtSpan;
use warp::Filter;

#[tokio::main]
async fn main() {
  let filter = std::env::var("RUST_LOG").unwrap_or_else(|_| "tracing=info,warp=debug".to_owned());

  tracing_subscriber::fmt()
    .with_env_filter(filter)
    .with_span_events(FmtSpan::CLOSE)
    .init();

  let hello = warp::path("hello")
    .and(warp::get())
    .map(|| "Hello, World!")
    .with(warp::trace::named("hello"));

  let goodbye = warp::path("goodbye")
    .and(warp::get())
    .map(|| "So long and thanks for all the fish!")
    // We can also provide our own custom `tracing` spans to wrap a route.
    .with(warp::trace(|info| {
      // Construct our own custom span for this route.
      tracing::info_span!("goodbye", req.path = ?info.path())
    }));

  let routes = hello
    .or(goodbye)
    // Wrap all the routes with a filter that creates a `tracing` span for
    // each request we receive, including data about the request.
    .with(warp::trace::request());

  warp::serve(routes).run(([127, 0, 0, 1], 3030)).await;
}
