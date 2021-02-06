

using Gtk;

namespace Graph {

    public class Smith : DrawingArea {

        //private Time time;
        //private int minute_offset;
        //private bool dragging;

        //public signal void time_changed (int hour, int minute);
        //
		private int Xsize;
		private int Ysize;
        private int x;
        private int y;
        private double r;

        public Smith () {
            //x = get_allocated_width () / 2;
            //y = get_allocated_height () / 2;
            //radius = double.min (get_allocated_width () / 2,
            //                     get_allocated_height () / 2) - 5;
            Xsize = 20;
            Ysize = 20;
            x = 100 / 2;
            y = 50 / 2;
            r = 25 - 5;

//            add_events (Gdk.EventMask.BUTTON_PRESS_MASK
//                      | Gdk.EventMask.BUTTON_RELEASE_MASK
//                      | Gdk.EventMask.POINTER_MOTION_MASK);
//            update ();

            // update the clock once a second
//            Timeout.add (1000, update);
        }

        private void redraw_canvas () {
            var window = get_window ();
            if (null == window) {
                return;
            }

            var region = window.get_clip_region ();
            // redraw the cairo canvas completely by exposing it
            window.invalidate_region (region, true);
            //window.process_updates (true);
        }

        public override bool draw (Cairo.Context cr) {
            Xsize = get_allocated_width ();
            Ysize = get_allocated_height ();
            var x1 = Xsize / 2;
            var y1 = Ysize / 2;
            var r1 = double.min (Xsize / 2, Ysize / 2) - 5;

            //
            cr.arc (x1, y1, r1, 0, 2 * Math.PI);
            //cr.set_source_rgb (1, 1, 1);
            //cr.fill_preserve ();
            //cr.set_source_rgb (0, 0, 0);
            cr.stroke ();

            //
            cr.arc (x, y, r, 0, 2 * Math.PI);
            //cr.set_source_rgb (1, 1, 1);
            //cr.fill_preserve ();
            //cr.set_source_rgb (0, 0, 0);
            cr.stroke ();

			cr.move_to (10, 10);
			cr.line_to (Xsize-10, 10);
			cr.line_to (Xsize-10, Ysize-10);
			cr.line_to (10, Ysize-10);
			cr.line_to (10, 10);
			cr.stroke ();

            return false;
        }

        public bool update () {
            // update the
            x = 200 / 2;
            y = 100 / 2;
            r = 50 - 5;

            redraw_canvas ();
            return true;        // keep running this event
        }

    }
}

