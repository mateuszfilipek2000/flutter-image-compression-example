use std::io::Cursor;

pub fn compress(image_bytes: Vec<u8>) -> Vec<u8> {
    let image = image::load_from_memory(&image_bytes).unwrap();
    let mut jpg_bytes = Cursor::new(Vec::new());
    image
        .write_to(&mut jpg_bytes, image::ImageOutputFormat::Jpeg(100))
        .unwrap();

    let mut comp = mozjpeg::Compress::new(mozjpeg::ColorSpace::JCS_RGB);

    let width = image.width() as usize;
    let height = image.height() as usize;

    comp.set_size(width, height);
    comp.set_quality(40.);

    let mut comp = comp.start_compress(Vec::new()).unwrap();

    let pixels = image.into_rgb8().into_raw();
    comp.write_scanlines(&pixels[..]).unwrap();
    comp.finish().unwrap()
}
