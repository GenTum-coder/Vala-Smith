/* graph.vala
 *
 * Copyright 2021 Gena <unknown@domain.org>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
*/

using Gtk;
using Math;

namespace Graph {

	public class Smith : DrawingArea {

		// private var
		private int Xsize;
		private int Ysize;
		private int MinXY;
		private int R;		// radius (1.0)
		private int C;		// center

		// public var
		public double[] Re;
		public double[] Im;
		public int      N;

		public Smith () {
			double alpha;
			Re = new double[2048];
			Im = new double[2048];
			N     = 0;
			Xsize = 20;
			Ysize = 20;
			MinXY = int.min (Xsize, Ysize);
			R     = MinXY/2 - 10;
			C     = MinXY/2;

			// for test
			for (int i=0;i<360;i++){
				alpha = i*2*Math.PI/360.0;
				Re[i] = Math.cos(alpha);
				Im[i] = Math.sin(alpha);
				N++;
			}

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
			MinXY = int.min (Xsize, Ysize);
			R     = MinXY/2 - 10;
			C     = MinXY/2;
			var x1 = Xsize / 2;
			var y1 = Ysize / 2;
			var r1 = double.min (Xsize / 2, Ysize / 2) - 5;

			cr.set_source_rgb (0.0, 0.0, 0.0);

			// set square
			cr.move_to (C - R, C - R);
			cr.line_to (C + R, C - R);
			cr.line_to (C + R, C + R);
			cr.line_to (C - R, C + R);
			cr.line_to (C - R, C - R);
			cr.stroke ();

			// set LAxis

			cr.set_source_rgb (0.85, 0.85, 0.85);

			// set 0,0 lines
			cr.move_to (C - R, C);
			cr.line_to (C + R, C);
			cr.move_to (C, C - R);
			cr.line_to (C, C + R);
			cr.stroke ();

			// set grids Smith real
			// r = 0.0 : C = r/(1 + r), 0 R = 1/(1 + r) : 0.0, 0.0, 1.0
			x1 = C + 0;
			y1 = C + 0;
			r1 = 1*R;
			cr.arc (x1, y1, r1, 0, 2 * Math.PI);
			// r = 0.2 : C = r/(1 + r), 0 R = 1/(1 + r) : 1.0/6.0, 0.0, 5.0/6.0
			x1 = C + R/6;
			y1 = C + 0;
			r1 = 5*R/6;
			cr.arc (x1, y1, r1, 0, 2 * Math.PI);
			//cr.stroke ();
			// r = 0.5 : C = r/(1 + r), 0 R = 1/(1 + r) : 1.0/3.0, 0.0, 2.0/3.0
			x1 = C + R/3;
			y1 = C + 0;
			r1 = 2*R/3;
			cr.arc (x1, y1, r1, 0, 2 * Math.PI);
			cr.stroke ();
			// r = 1.0 : C = r/(1 + r), 0 R = 1/(1 + r) : 0.5, 0.0, 0.5
			// reference (Z = 50 Ohm)
			cr.set_source_rgb (0.9, 0.0, 0.7);
			x1 = C + R/2;
			y1 = C + 0;
			r1 = 1*R/2;
			cr.arc (x1, y1, r1, 0, 2 * Math.PI);
			cr.stroke ();
			cr.set_source_rgb (0.85, 0.85, 0.85);
			// r = 2.0 : C = r/(1 + r), 0 R = 1/(1 + r) : 2.0/3.0, 0.0, 1.0/3.0
			x1 = C + 2*R/3;
			y1 = C + 0;
			r1 = 1*R/3;
			cr.arc (x1, y1, r1, 0, 2 * Math.PI);
			// r = 5.0 : C = r/(1 + r), 0 R = 1/(1 + r) : 5.0/6.0, 0.0, 1.0/6.0
			x1 = C + 5*R/6;
			y1 = C + 0;
			r1 = 1*R/6;
			cr.arc (x1, y1, r1, 0, 2 * Math.PI);
			cr.stroke ();

			// set grids Smith im
			double alpha;
			double x2;
			double y2;
			double r2;
			// x = 0.2 : C = 1 , 1/x R = 1/x : 1.0, 5.0, 5.0 : 180 < a <= 270
			// x = -0.2 : C = 1 , 1/x R = 1/x : 1.0, -5.0, -5.0
			alpha = Math.PI;
			while (Math.cos(alpha)<-2.0/5.0) {alpha += Math.PI/360.0;}
			x2 = 1.0 + 5.0*Math.cos(alpha);
			y2 = 5.0 + 5.0*Math.sin(alpha);
			r2 = Math.sqrt((x2*x2) + (y2*y2));
			while (r2 > 1.0) {
				alpha += Math.PI/360.0;
				x2 = 1.0 + 5.0*Math.cos(alpha);
				y2 = 5.0 + 5.0*Math.sin(alpha);
				r2 = Math.sqrt((x2*x2) + (y2*y2));
			}
			cr.arc (C + R, C - 5*R, 5*R, Math.PI/2.0, 3.0*Math.PI/2.0-alpha+Math.PI/2.0);
			cr.stroke ();
			cr.arc (C + R, C + 5*R, 5*R, alpha, 3.0*Math.PI/2.0);
			//cr.arc (C + R, C - R/2, R/2, Math.PI/2.0, 3.0*Math.PI/2.0);
			//cr.arc (C + R, C + R/2, R/2, Math.PI/2.0, 3.0*Math.PI/2.0);
			cr.stroke ();
			// x = 0.5 : C = 1 , 1/x R = 1/x : 1.0, 2.0, 2.0 : 180 < a <= 270
			// x = -0.5 : C = 1 , 1/x R = 1/x : 1.0, -2.0, -2.0
			alpha = Math.PI;
			while (Math.cos(alpha)<-2.0/2.0) {alpha += Math.PI/360.0;}
			x2 = 1.0 + 2.0*Math.cos(alpha);
			y2 = 2.0 + 2.0*Math.sin(alpha);
			r2 = Math.sqrt((x2*x2) + (y2*y2));
			while (r2 > 1.0) {
				alpha += Math.PI/360.0;
				x2 = 1.0 + 2.0*Math.cos(alpha);
				y2 = 2.0 + 2.0*Math.sin(alpha);
				r2 = Math.sqrt((x2*x2) + (y2*y2));
			}
			cr.arc (C + R, C - 2*R, 2*R, Math.PI/2.0, 3.0*Math.PI/2.0-alpha+Math.PI/2.0);
			cr.stroke ();
			cr.arc (C + R, C + 2*R, 2*R, alpha, 3.0*Math.PI/2.0);
			cr.stroke ();
			// x = 1.0 : C = 1 , 1/x R = 1/x : 1.0, 1.0, 1.0 : 90 < a <= 270
			// x = 1.0 : C = 1 , 1/x R = 1/x : 1.0, -1.0, -1.0
			alpha = Math.PI/2.0;
			while (Math.cos(alpha)<-2.0/1.0) {alpha += Math.PI/360.0;}
			x2 = 1.0 + 1.0*Math.cos(alpha);
			y2 = 1.0 + 1.0*Math.sin(alpha);
			r2 = Math.sqrt((x2*x2) + (y2*y2));
			while (r2 > 1.0) {
				alpha += Math.PI/360.0;
				x2 = 1.0 + 1.0*Math.cos(alpha);
				y2 = 1.0 + 1.0*Math.sin(alpha);
				r2 = Math.sqrt((x2*x2) + (y2*y2));
			}
			cr.arc (C + R, C - 1*R, 1*R, Math.PI/2.0, 3.0*Math.PI/2.0-alpha+Math.PI/2.0);
			cr.stroke ();
			cr.arc (C + R, C + 1*R, 1*R, alpha, 3.0*Math.PI/2.0);
			cr.stroke ();
			// x = 2.0 : C = 1 , 1/x R = 1/x : 1.0, 0.5, 0.5 : 90 < a <= 270
			// x = -2.0 : C = 1 , 1/x R = 1/x : 1.0, -0.5, -0.5
			alpha = Math.PI/2.0;
			while (Math.cos(alpha)<-2.0/0.5) {alpha += Math.PI/360.0;}
			x2 = 1.0 + 0.5*Math.cos(alpha);
			y2 = 0.5 + 0.5*Math.sin(alpha);
			r2 = Math.sqrt((x2*x2) + (y2*y2));
			while (r2 > 1.0) {
				alpha += Math.PI/360.0;
				x2 = 1.0 + 0.5*Math.cos(alpha);
				y2 = 0.5 + 0.5*Math.sin(alpha);
				r2 = Math.sqrt((x2*x2) + (y2*y2));
			}
			cr.arc (C + R, C - R/2, R/2, Math.PI/2.0, 3.0*Math.PI/2.0-alpha+Math.PI/2.0);
			cr.stroke ();
			cr.arc (C + R, C + R/2, R/2, alpha, 3.0*Math.PI/2.0);
			cr.stroke ();
			// x = 5.0 : C = 1 , 1/x R = 1/x : 1.0, 0.2, 0.2 : 90 < a <= 270
			// x = -5.0 : C = 1 , 1/x R = 1/x : 1.0, -0.2, -0.2
			alpha = Math.PI/2.0;
			while (Math.cos(alpha)<-2.0/0.2) {alpha += Math.PI/360.0;}
			x2 = 1.0 + 0.2*Math.cos(alpha);
			y2 = 0.2 + 0.2*Math.sin(alpha);
			r2 = Math.sqrt((x2*x2) + (y2*y2));
			while (r2 > 1.0) {
				alpha += Math.PI/360.0;
				x2 = 1.0 + 0.2*Math.cos(alpha);
				y2 = 0.2 + 0.2*Math.sin(alpha);
				r2 = Math.sqrt((x2*x2) + (y2*y2));
			}
			cr.arc (C + R, C - R/5, R/5, Math.PI/2.0, 3.0*Math.PI/2.0-alpha+Math.PI/2.0);
			cr.stroke ();
			cr.arc (C + R, C + R/5, R/5, alpha, 3.0*Math.PI/2.0);
			cr.stroke ();

			//cr.set_source_rgb (1, 1, 1);
			cr.set_source_rgb (0.0, 0.0, 0.0);

			//
			cr.set_source_rgb (0.0, 0.8, 0.0);
			x1 = 10 + R + (int)Math.floor(R*Re[0]);
			y1 = 10 + R + (int)Math.floor(R*Im[0]);
			cr.move_to (x1, y1);
			for (int i=1; i<N;i++) {
				x1 = 10 + R + (int)Math.floor(R*Re[i]);
				y1 = 10 + R + (int)Math.floor(R*Im[i]);
				cr.line_to (x1, y1);
			}
			cr.stroke ();

			return false;
		}

		public bool update () {
			// update the

			redraw_canvas ();
			return true;        // keep running this event
		}

		public bool clear () {
			// update the
			N = 0;
			redraw_canvas ();
			return true;        // keep running this event
		}

		public bool add (double re, double im) {
			// update the
			Re[N] = re;
			Im[N] = im;
			N++;
			redraw_canvas ();
			return true;        // keep running this event
		}

	}
}

