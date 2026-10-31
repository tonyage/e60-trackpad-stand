// Sunder E60 HE + Apple Magic Trackpad 2 desk stand
// Layout (as seen from your chair):  [ LEFT HALF ][ TRACKPAD ][ RIGHT HALF ]
//
// - Each keyboard half sits in a pocket on a wedge tilted to the trackpad's own angle (~3 deg).
// - The trackpad sits in a pocket on a riser so its top surface is coplanar with the
//   keyboard cases' top surface (front edges aligned).
// - Three separate pieces (each fits a 256 mm bed), locked together from underneath with
//   printed bowtie keys. Recesses on the bottom take 10 mm adhesive rubber bumpers.
// - The keyboard halves keep their own pill feet on; they grip the pocket floor.
//
// Set `part` and export each piece to STL (F6 then F7 in OpenSCAD).

part = "assembly"; // [assembly, plate, left, right, trackpad, keys, bracket, brackets_plate, left_vertical, right_vertical, fit_test_kb, fit_test_tp, section]

/* [Keyboard half - MEASURE THESE] */
kb_w = 135.5;   // left-right width of one half (measured)
kb_d = 120.5;   // front-back depth of one half (measured)
kb_h = 19.5;    // case height on its pill feet (Sunder spec: 18.5 bare + 1 mm feet)

/* [Magic Trackpad 2 - Apple spec] */
tp_w = 160;
// Left-right gap per side. Print 1 (flat): 0.4 -> 1.43 mm of play. Print 2 (upright): -0.165
// -> too tight to fit. 0 gives a 160.0 mm nominal pocket, ~0.6 mm of play printed flat.
tp_clr = 0;
tp_d = 114.9;
tp_h_front = 4.9;
tp_h_back = 10.9;

/* [Fit] */
clr = 0.4;          // gap around each device, per side
wall = 3;           // pocket wall thickness
floor_t = 2.4;      // keyboard wedge floor thickness at the front
kb_front_lip = 3;   // lower front lip so it stays out of the way of your wrists
dev_r = 7;          // corner radius shared by the E60 halves and the trackpad (estimated from
                    // photos; keep it at or below the real radius or the corners will bind)
pocket_r = dev_r + clr;      // pocket follows the device outline at a constant gap

/* [Keyboard bracket] */
// A ring that drops into a rebate in the top of the pocket after the keyboard is in, and
// fills the gap between the pocket wall and the case (including the V left by the E60's
// top-edge chamfer), so wall, bracket and case tops read as one flush surface.
kb_cover = true;
ring_w = 1.5;         // rebate cut into the pocket wall (leaves wall - ring_w of outer wall)
ring_d = 4;           // rebate / bracket depth below the top plane
ring_fit = 0.15;      // gap between bracket and rebate wall
ring_clr = 0.15;      // gap between bracket and keyboard case
kb_chamfer = 1.45;    // E60 top-edge chamfer, horizontal width (measured)
kb_chamfer_h = 1.45;  // E60 top-edge chamfer, vertical height (measured)
// Flat top face corner radius. The chamfer measures 2 mm across at the corners (vs 1.45 on
// the straights), which a 7 mm case radius gives when the flat face's radius is ~6.9 mm.
kb_top_r = 6.9;

/* [Cable notches] */
// Two ports per half, spaced symmetrically: center measured 27 mm from each case end.
usb_from_edge = 27;
usb_notch_w = 16;
usb_notch_h = 12;   // window height above the pocket floor; port center is ~6 mm up
                    // (incl. feet), plug overmold ~7 mm tall, so the wall above is closed
tp_notch_w = 60;          // centered notch in the trackpad's back wall (charging port)
tp_back_left_block = 13;  // length of the riser's back-left wall block, from its outer left edge
tp_back_right_block = 11; // length of the riser's back-right wall block, from its outer right edge
tp_side_wall = 1.5;       // riser left/right walls; matches the wedge wall left beside the bracket

/* [Hollowing (trackpad riser + keyboard wedges)] */
tp_hollow = true;
kb_hollow = true;
tp_shell = 2.4;    // pocket floor thickness over the hollow
tp_side_rim = 19;  // solid band at each joint side (bowtie slots + feet recesses)
tp_rim = 3;        // front/back outer wall
tp_rib_t = 2;      // rib thickness
tp_rib_gap = 20;   // max bridge span between ribs (keyboard wedges)
// Riser only (the keyboard wedges keep the values above):
tp_riser_shell = 1.6;    // pocket floor thickness over the hollow
tp_riser_rib_gap = 30;   // max bridge span between ribs
tp_windows = true;       // open the pocket floor between the ribs
tp_ledge = 10;           // solid floor kept around the pocket edge for the trackpad's feet
push_l = 40;       // front-back length of the push-out slots in the keyboard wedge floors

/* [Feet + joining keys] */
foot_d = 10.5;    // recess diameter for 10 mm self-adhesive rubber bumpers
foot_depth = 1;
foot_inset = 12;
key_neck = 8;     // bowtie width at the joint line
key_end = 14;     // bowtie width at its ends
key_half = 10;    // bowtie half-length (each side of the joint)
key_t = 2.4;      // key thickness
key_slot = 2.6;   // slot depth
key_clr = 0.05;   // in-plane clearance between key and slot (keys only; slots unchanged)
key_inset = 25;   // key distance from the front/back edges

$fn = 64;
eps = 0.01;

// ---------------------------------------------------------------- derived
angle = atan((tp_h_back - tp_h_front) / tp_d);

kb_zt = floor_t + kb_h;
kb_lean = kb_zt*sin(angle);  // how far the tilted pocket's top leans forward of its floor

// All pieces share this depth; the extra kb_lean keeps the wedge's back wall full thickness.
D  = max(kb_d, tp_d) + 2*clr + 2*wall + kb_lean;
Wk = kb_w + 2*clr + 2*wall;
Wt = tp_w + 2*tp_clr + 2*tp_side_wall;
kb_corner_r = pocket_r + wall;  // rounded outer corners of the wedges (outer side only)

// Keyboard top-front edge in world coords (wedge pivots about its front-bottom edge). The
// pocket is set back by the lean so the case's top-front edge lines up with the trackpad's
// front and the front wall is a full `wall` thick at the top.
kb_yt = (wall + clr + kb_lean) / cos(angle);
kb_py = kb_yt - clr;            // pocket front in the tilted frame
kb_top_y = kb_yt*cos(angle) - kb_zt*sin(angle);
kb_top_z = kb_yt*sin(angle) + kb_zt*cos(angle);
// Trackpad riser height so its top surface lands on the keyboard's top plane.
tp_front_y = wall + clr;
R = kb_top_z + (tp_front_y - kb_top_y)*tan(angle) - tp_h_front;

echo(str("Tilt angle: ", angle, " deg"));
echo(str("Trackpad riser height: ", R, " mm"));
function kb_plane(y) = kb_top_z + (y - kb_top_y)*tan(angle);
tp_back_y = tp_front_y + tp_d;
echo(str("Front: trackpad top ", R + tp_h_front, "  keyboard plane ", kb_plane(tp_front_y)));
echo(str("Back:  trackpad top ", R + tp_h_back,  "  keyboard plane ", kb_plane(tp_back_y)));
echo(str("Keyboard piece: ", Wk, " x ", D, " mm   Trackpad piece: ", Wt, " x ", D, " mm"));

// ---------------------------------------------------------------- helpers
module tilt() rotate([angle, 0, 0]) children();

// Everything below the shared top plane (keyboard case tops = trackpad top), W wide,
// optionally lowered by `off` measured square to the plane.
module below_top_plane(W, off = 0)
    translate([-1, 0, kb_plane(0)]) rotate([angle, 0, 0])
        translate([0, -D, -100 - off]) cube([W + 2, 3*D, 100]);

module rbox(w, d, h, r) linear_extrude(h) offset(r) offset(-r) square([w, d]);

module bowtie_2d(neck, endw, half)
    polygon([[-half, -endw/2], [0, -neck/2], [half, -endw/2],
             [half, endw/2], [0, neck/2], [-half, endw/2]]);

// Bowtie slots straddling a joint line at x = jx (only the half inside this piece matters).
module key_slots(jx) {
    for (y = [key_inset, D - key_inset])
        translate([jx, y, -eps]) linear_extrude(key_slot + eps) bowtie_2d(key_neck, key_end, key_half);
}

module feet(W) {
    for (x = [foot_inset, W - foot_inset], y = [foot_inset, D - foot_inset])
        translate([x, y, -eps]) cylinder(d = foot_d, h = foot_depth + eps);
}

// ---------------------------------------------------------------- keyboard wedge
// inner_on_right: true for the LEFT half (its inner edge, toward the trackpad, is at x = Wk)
module kb_piece(inner_on_right) {
    px0 = wall + clr;                      // pocket x origin of the keyboard itself
    notches = [px0 + usb_from_edge, px0 + kb_w - usb_from_edge];

    difference() {
        // Block cut on the shared top plane, so the outer faces are vertical and the
        // side/back wall tops meet the trackpad riser edge for edge. The two corners on the
        // outer side are rounded; the inner side stays square to butt against the riser.
        intersection() {
            union() {
                rbox(Wk, D, 100, kb_corner_r);
                translate([inner_on_right ? Wk/2 : 0, 0, 0]) cube([Wk/2, D, 100]);
            }
            below_top_plane(Wk);
        }
        // keyboard pocket
        tilt() translate([wall, kb_py, floor_t]) rbox(kb_w + 2*clr, kb_d + 2*clr, 50, pocket_r);
        // rebate for the bracket around the top of the pocket
        if (kb_cover)
            tilt() translate([wall - ring_w, kb_py - ring_w, kb_zt - ring_d])
                rbox(kb_w + 2*clr + 2*ring_w, kb_d + 2*clr + 2*ring_w, 50, pocket_r + ring_w);
        // lower front lip (only without the bracket, which runs across the front too)
        if (!kb_cover)
            tilt() translate([-1, -10, floor_t + kb_front_lip]) cube([Wk + 2, kb_py + 10 + eps, 50]);
        // USB-C notches in the back wall
        for (x = notches)
            tilt() translate([x - usb_notch_w/2, D - wall - 1, floor_t]) cube([usb_notch_w, wall + 10, usb_notch_h]);
        // Hollow floor: cells up to tp_shell below the tilted pocket floor (they grow
        // from nothing at the front to ~6.7 mm at the back).
        if (kb_hollow)
            intersection() {
                cells(Wk, 50);
                tilt() translate([-1, -D, -100]) cube([Wk + 2, 3*D, 100 + floor_t - tp_shell]);
            }
        // Push-out slots through the floor, filling the second and second-to-last cells
        // rib to rib at mid-depth: push up through them to pop the keyboard out.
        if (kb_hollow)
            for (i = [1, cell_n(Wk) - 2])
                translate([cell_x(Wk, i), D/2 - push_l/2, -1])
                    cube([cell_w(Wk), push_l, 50]);
        feet(Wk);
        key_slots(inner_on_right ? Wk : 0);
    }
}

// ---------------------------------------------------------------- keyboard bracket
// Same for both halves. Built in the tilted (keyboard) frame; its top is the case top (kb_zt).
module kb_bracket() {
    px = wall + clr;
    o = ring_w - ring_fit;                        // outer edge, out from the pocket wall
    fi = kb_chamfer - ring_clr;                   // flat-face inset from the case edge
    translate([0, kb_py - wall, 0]) difference() {
        translate([wall - o, wall - o, kb_zt - ring_d])
            rbox(kb_w + 2*clr + 2*o, kb_d + 2*clr + 2*o, ring_d, pocket_r + o);
        // case body below the chamfer
        translate([px - ring_clr, px - ring_clr, kb_zt - ring_d - 1])
            rbox(kb_w + 2*ring_clr, kb_d + 2*ring_clr, ring_d + 1 - kb_chamfer_h + eps, dev_r + ring_clr);
        // chamfer
        hull() {
            translate([px - ring_clr, px - ring_clr, kb_zt - kb_chamfer_h])
                rbox(kb_w + 2*ring_clr, kb_d + 2*ring_clr, eps, dev_r + ring_clr);
            translate([px + fi, px + fi, kb_zt]) rbox(kb_w - 2*fi, kb_d - 2*fi, eps, kb_top_r + ring_clr);
        }
        translate([px + fi, px + fi, kb_zt]) rbox(kb_w - 2*fi, kb_d - 2*fi, 1, kb_top_r + ring_clr);
    }
}

// Bracket flipped top-face-down for printing (the chamfer lip then needs no support).
module bracket_print() rotate([180, 0, 0]) translate([0, 0, -kb_zt]) kb_bracket();

// Both brackets front-to-back on one 256 mm bed (each ~139 x 124, so side by side won't fit).
brackets_gap = 4;
module brackets_plate() {
    o  = ring_w - ring_fit;
    bw = kb_w + 2*clr + 2*o;
    bd = kb_d + 2*clr + 2*o;
    for (i = [0, 1])
        translate([-bw/2 - (wall - o), -(bd + brackets_gap/2) + i*(bd + brackets_gap) + (kb_py - o + bd), 0])
            bracket_print();
}

// ---------------------------------------------------------------- trackpad riser
// Open-bottom cells separated by front-to-back ribs; the slicer bridges each cell's roof.
// Shared by the riser and the keyboard wedges: cells h tall across a piece W wide, with
// ribs at most `gap` apart.
function cell_n(W, gap = tp_rib_gap) = ceil((W - 2*tp_side_rim + tp_rib_t) / (gap + tp_rib_t));
function cell_w(W, gap = tp_rib_gap) = (W - 2*tp_side_rim - (cell_n(W, gap) - 1)*tp_rib_t) / cell_n(W, gap);
function cell_x(W, i, gap = tp_rib_gap) = tp_side_rim + i*(cell_w(W, gap) + tp_rib_t);   // left edge of cell i
module cells(W, h, gap = tp_rib_gap) {
    for (i = [0:cell_n(W, gap) - 1])
        translate([cell_x(W, i, gap), tp_rim, -eps])
            cube([cell_w(W, gap), D - 2*tp_rim, h + eps]);
}
module tp_cavity() {
    cells(Wt, R - tp_riser_shell, tp_riser_rib_gap);
    // Windows through the pocket floor: the trackpad rests on a perimeter ledge and the rib tops.
    if (tp_windows)
        for (i = [0:cell_n(Wt, tp_riser_rib_gap) - 1])
            intersection() {
                translate([cell_x(Wt, i, tp_riser_rib_gap), 0, -1])
                    cube([cell_w(Wt, tp_riser_rib_gap), D, R + 2]);
                translate([tp_side_wall + tp_ledge, wall + tp_ledge, -1])
                    cube([tp_w + 2*tp_clr - 2*tp_ledge, tp_d + 2*clr - 2*tp_ledge, R + 2]);
            }
}

// The riser's top is cut on the trackpad's (and keyboards') top plane, so the trackpad
// sits flush with the block all the way round.
module tp_piece() {
    difference() {
        intersection() {
            cube([Wt, D, 100]);
            below_top_plane(Wt);
        }
        if (tp_hollow) tp_cavity();
        translate([tp_side_wall, wall, R]) rbox(tp_w + 2*tp_clr, tp_d + 2*clr, 50, pocket_r);
        // Back-wall notches start just ahead of the pocket's back corners, so the front
        // corners keep their radius.
        notch_y = wall + tp_d + 2*clr - pocket_r - 1;
        translate([Wt/2 - tp_notch_w/2, notch_y, R]) cube([tp_notch_w, D, 50]);
        // trim the back-left block down to tp_back_left_block, measured from the left edge
        translate([tp_back_left_block, notch_y, R])
            cube([Wt/2 - tp_notch_w/2 - tp_back_left_block + eps, D, 50]);
        // and the back-right block down to tp_back_right_block, measured from the right edge
        translate([Wt/2 + tp_notch_w/2 - eps, notch_y, R])
            cube([Wt/2 - tp_notch_w/2 - tp_back_right_block + eps, D, 50]);
        feet(Wt);
        key_slots(0);
        key_slots(Wt);
    }
}

// ---------------------------------------------------------------- loose parts
module keys() {
    for (i = [0:3])
        translate([0, i*(key_end + 4), 0])
            linear_extrude(key_t) offset(delta = -key_clr) bowtie_2d(key_neck, key_end, key_half);
}

module fit_ring(w, d, cx = clr) {
    difference() {
        rbox(w + 2*cx + 2*wall, d + 2*clr + 2*wall, 4, pocket_r + wall);
        translate([wall, wall, -1]) rbox(w + 2*cx, d + 2*clr, 6, pocket_r);
    }
}

// Keyboard wedge stood on its back edge (back face on the bed, front edge up).
module upright() translate([0, 0, D]) rotate([-90, 0, 0]) children();
module kb_vertical(inner_on_right) upright() kb_piece(inner_on_right);
// Riser stood the same way; its cells become vertical channels.
module tp_vertical() upright() tp_piece();

// Upright, the wedge's full-height front wall becomes a ~136 mm wide ceiling over the
// pocket: it needs tree supports grown from the back wall's inner face (support "on build
// plate only" OFF), or it frays. Otherwise print left/right/trackpad flat, one per plate.
// One X1C plate (256 x 256): riser and both wedges upright in three rows. The keys are
// printed separately (part = "keys").
kb_thick = kb_plane(D) + 1;  // piece thickness when upright (its tallest point, at the back)
plate_gap = 12;
module plate() {
    tp_vertical();
    for (i = [0, 1])
        translate([(Wt - Wk)/2, (i + 1)*(kb_thick + plate_gap), 0])
            kb_vertical(i == 0);
}
echo(str("Vertical plate footprint: ", Wt, " x ",
         3*kb_thick + 2*plate_gap, " mm, height ", D, " mm"));

// Ghost devices for the assembly preview
module ghosts() {
    tilt() translate([wall + clr, kb_yt, floor_t]) rbox(kb_w, kb_d, kb_h, dev_r);
}

// ---------------------------------------------------------------- output
gap = 0.5;
if (part == "assembly") {
    kb_piece(true);
    if (kb_cover) color("dimgray") tilt() kb_bracket();
    %ghosts();
    translate([Wk + gap, 0, 0]) {
        tp_piece();
        %translate([tp_side_wall + tp_clr, wall + clr, R])
            rotate([90, 0, 90]) linear_extrude(tp_w)
                polygon([[0, 0], [tp_d, 0], [tp_d, tp_h_back], [0, tp_h_front]]);
    }
    translate([Wk + Wt + 2*gap, 0, 0]) {
        kb_piece(false);
        if (kb_cover) color("dimgray") tilt() kb_bracket();
        %ghosts();
    }
}
else if (part == "left")        kb_piece(true);
else if (part == "right")       kb_piece(false);
else if (part == "trackpad")    tp_piece();
else if (part == "keys")        keys();
else if (part == "fit_test_kb") fit_ring(kb_w, kb_d);
else if (part == "fit_test_tp") fit_ring(tp_w, tp_d, tp_clr);
else if (part == "bracket")     bracket_print();
else if (part == "brackets_plate") brackets_plate();
else if (part == "section")     // cut through the left wedge + bracket to check the profile
    intersection() {
        union() { kb_piece(true); tilt() kb_bracket(); }
        translate([-1, D/2, -1]) cube([25, 1, 40]);
    }
else if (part == "section_fb")  // front-to-back cut through the left wedge + bracket
    intersection() {
        union() { kb_piece(true); tilt() kb_bracket(); }
        translate([Wk/2, -1, -1]) cube([1, D + 2, 40]);
    }
else if (part == "left_vertical")  kb_vertical(true);
else if (part == "right_vertical") kb_vertical(false);
else if (part == "trackpad_vertical") tp_vertical();
else if (part == "plate")          plate();
