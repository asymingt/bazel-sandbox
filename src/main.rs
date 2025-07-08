extern crate runfiles; // Import the library

use runfiles::{Runfiles, rlocation};
use std::fs::File;
use std::io::Read;

fn main() {
    // Create a Runfiles object
    let r = Runfiles::create().unwrap(); 

    // Use rlocation to find the data file
    let path = rlocation!(r, "experimental/data/foo.txt").expect("Failed to locate runfile");

    // Open and read the data file
    let mut f = File::open(path).unwrap();
    let mut contents = String::new();
    f.read_to_string(&mut contents).unwrap();

    println!("Content: {}", contents);
}