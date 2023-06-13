use tes3::esp::{Plugin, Door};
fn main() -> std::io::Result<()> {
    let mut plugin = Plugin::new();
    plugin.load_path("../Morrowind.esm")?;

    for object in plugin.objects_of_type::<Door>() {
        if object.id == "fargoth" {
            println!("{object:#?}");
        }
    }

    Ok(())
}

fn get_no_door_cells() {
    for &cell in &tes3.dataHandler.nonDynamicData.cells {
        if &cell.isInterior {
            for &door in &cell.iterateReferences(&tes3.objectType.door) {
                if &door.destination {
                    println!("{}", &cell.editorName);
                    break;
                }
            }
        }
    }
}
