use rocket::{get, launch, routes};
use rocket::State;
use std::env;
use std::fs::File;
use std::io::Read;
use std::sync::{Arc, Mutex};

struct Counter {
    value: i32,
    username: String,
}

#[get("/")]
fn index(counter: &State<Arc<Mutex<Counter>>>) -> String {
    let counter_lock = counter.lock().unwrap();
    format!("Hi {}!\nCounter: {}", counter_lock.username, counter_lock.value)
}

#[get("/add")]
fn increment(counter: &State<Arc<Mutex<Counter>>>) -> String {
    let mut counter_lock = counter.lock().unwrap();
    counter_lock.value += 1;
    format!("Hi {}!\nIncremented!\nNew value: {}", counter_lock.username, counter_lock.value)
}

#[get("/reset")]
fn reset(counter: &State<Arc<Mutex<Counter>>>) -> String {
    let mut counter_lock = counter.lock().unwrap();
    counter_lock.value = 0;
    format!("Hi {}!\nReset Success!\nCounter: {}", counter_lock.username, counter_lock.value)
}

#[launch]
fn rocket() -> _ {
    let config_path: String = match env::var("CONFIG_PATH") {
        Ok(val) => val,
        Err(_) => "config.yaml".to_string(),
    };
    println!("Using config file: {config_path}");

    let mut f: File = std::fs::File::open(config_path).expect("Can't open config.yaml");

    let mut str: String = String::new();
    f.read_to_string(&mut str).expect("Can't read config.yaml");

    let data: serde_yaml::Value = serde_yaml::from_str(&str).expect("Can't parse config.yaml");
    let username: String = data["username"]
        .as_str()
        .map(|s| s.to_string())
        .expect("Can't find username in config.yaml");

    rocket::build()
        .manage(Arc::new(Mutex::new(Counter { value: 0, username: username })))
        .mount("/", routes![index, increment, reset])
}
