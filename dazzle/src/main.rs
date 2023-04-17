use tracing_subscriber::fmt::format::FmtSpan;
use warp::Filter;
use serde_derive::{Serialize, Deserialize};
use http::header::{HeaderValue, HeaderName};

#[derive(Deserialize, Serialize)]
struct Employee {
    name: String,
    rate: u32,
}

impl Employee {
    fn new(name: &str, rate: u32) -> Self {
        Self {
            name: name.to_owned(),
            rate,
        }
    }
}

#[tokio::main]
async fn main() {
  let filter = std::env::var("RUST_LOG").unwrap_or_else(|_| "tracing=info,warp=debug".to_owned());
  let json = HeaderValue::from_static("application/json");
  let server_key = HeaderName::from_static("server");
  let server =  HeaderValue::from_static("dazzle");

  tracing_subscriber::fmt()
    .with_env_filter(filter)
    .with_span_events(FmtSpan::CLOSE)
    .init();

  let root = warp::path::end().map(|| "Welcome to my warp server!").boxed();

  let hello = warp::path("hello")
    .and(warp::get())
    .map(|| "Hello, razzle dazzle!");

  let goodbye = warp::path("goodbye")
    .and(warp::get())
    .map(|| warp::reply::json(&Employee::new("Bob", 20)));

  let healthz = warp::path("healthz")
    .and(warp::get())
    .map(|| "OK");

  let routes = root
    .or(hello)
    .or(goodbye)
    .or(healthz)
    .with(warp::reply::with::header(http::header::CONTENT_TYPE, json))
    .with(warp::reply::with::header(server_key, server))
    .with(warp::trace::request());

  warp::serve(routes).run(([127, 0, 0, 1], 3030)).await;
}
