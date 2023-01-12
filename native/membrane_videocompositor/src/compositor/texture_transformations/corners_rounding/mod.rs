use bytemuck::{Pod, Zeroable};

use crate::compositor::VideoProperties;

use super::TextureTransformation;

/// Struct representing parameters for video corners rounding texture transformation.
/// border_radius is value representing the radius of the circle in pixels "cutting"
/// frame corner part.
#[derive(Debug, Clone, Copy, Zeroable, Pod, PartialEq)]
#[repr(C)]
pub struct CornersRounding {
    pub border_radius: f32,
}

impl TextureTransformation for CornersRounding {
    fn update_video_properties(&mut self, _properties: VideoProperties) {}

    fn transform_video_properties(&self, properties: VideoProperties) -> VideoProperties {
        properties
    }

    fn shader_module(device: &wgpu::Device) -> wgpu::ShaderModule {
        device.create_shader_module(wgpu::include_wgsl!("corners_rounding.wgsl"))
    }

    fn data(&self) -> &[u8] {
        bytemuck::cast_slice(std::slice::from_ref(self))
    }

    fn transformation_name() -> &'static str {
        "corners rounding"
    }

    fn transformation_name_dyn(&self) -> &'static str {
        "corners rounding"
    }
}
