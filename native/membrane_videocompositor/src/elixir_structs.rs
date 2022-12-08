#![allow(clippy::needless_borrow)]

#[derive(Debug, rustler::NifStruct, Clone)]
#[module = "Membrane.VideoCompositor.RustStructs.RawVideo"]
pub struct ElixirRawVideo {
    pub width: u32,
    pub height: u32,
    pub pixel_format: rustler::Atom,
    pub framerate: (u64, u64),
}

#[derive(Debug, rustler::NifStruct, Clone, Copy)]
#[module = "Membrane.VideoCompositor.RustStructs.VideoPlacement"]
pub struct ElixirVideoPlacement {
    pub position: (u32, u32),
    pub display_size: (u32, u32),
    pub z_value: f32,
}