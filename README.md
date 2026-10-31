# Sunder E60 HE + Magic Trackpad 2 stand

A three-piece 3D-printed stand that holds a Sunder E60 HE split keyboard and an Apple Magic
Trackpad 2 side by side: `[LEFT HALF][TRACKPAD][RIGHT HALF]`. The keyboard halves are tilted
to match the trackpad's ~3° slope so every top surface is coplanar, and the trackpad sits flush
in its riser. The pieces join underneath with bowtie keys.

Designed for a Bambu Lab X1-Carbon (256 × 256 mm bed).

![Assembly, top view](preview_assembly_top.png)

## Files

| File | What it is |
| --- | --- |
| `e60_trackpad_stand.scad` | Parametric OpenSCAD model (source of truth) |
| `stl/left.stl`, `stl/right.stl` | Keyboard wedges, flat |
| `stl/trackpad.stl` | Trackpad riser, flat |
| `stl/*_vertical.stl` | The same pieces stood upright |
| `stl/plate.stl` | Riser + both wedges upright on one plate |
| `stl/bracket.stl` | Top bracket that fills the keyboard case chamfer (print 2, top face down) |
| `stl/brackets_plate.stl` | Both brackets on one plate |
| `stl/keys.stl` | Four bowtie joining keys |
| `stl/fit_test_kb.stl`, `stl/fit_test_tp.stl` | Thin rings for checking pocket fit |

## Exporting

Open the `.scad` in OpenSCAD 2021.01+, set `part` in the Customizer (or with `-D`), and export:

```
openscad -o stl/left.stl -D "part=\"left\"" e60_trackpad_stand.scad
```

`part` options: `assembly`, `plate`, `left`, `right`, `trackpad`, `keys`, `bracket`,
`brackets_plate`, `left_vertical`, `right_vertical`, `trackpad_vertical`, `fit_test_kb`,
`fit_test_tp`, `section`, `section_fb`.

## Printing notes

- Flat is the easiest orientation. Upright prints need tree supports (not "build plate only")
  under the wedge's front wall, or that ceiling frays.
- For a smoother sloped top, use a fine layer height (0.08 mm) over the top few millimetres and
  enable ironing.
- Print the brackets top face down; the chamfer lip then needs no support.
- Stick 10 mm rubber bumpers in the foot recesses.

## Key dimensions (tweak in the Customizer)

- `kb_w`, `kb_d`: keyboard half footprint (135.5 × 120.5 mm measured)
- `tp_w`: trackpad pocket width (160 mm)
- `clr`: pocket clearance per side (0.4 mm)
- `key_clr`: bowtie key clearance (0.05 mm; raise to 0.1 if the keys are too tight)
- `tp_side_wall`: riser side wall (1.5 mm)
