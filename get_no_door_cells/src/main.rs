fn main() {
    get_no_door_cells();
}

fn get_no_door_cells() {
    // let cells = tes3.dataHandler.nonDynamicData.cells
    use std::collections::HashMap;

    let mut objectType = HashMap::new();

    objectType.insert(String::from("door"), 1380929348);

    struct Tes3Cell {
        isInterior: bool,
        iterateReferences: fn(),
    }
   let cells: &[Tes3Cell];
    for cell in &cells {
        if cell.isInterior {
            for door in cell:iterateReferences(objectType.door) {
                if door.destination {
                    println!(cell.editorName);
                    break;
                }
            }
        }
    }
}