/* window.vala
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
 */

using Gtk;
using Graph;

namespace ValaSmith {
	[GtkTemplate (ui = "/org/example/vala-smith/window.ui")]
	public class Window : Gtk.ApplicationWindow {
		[GtkChild] Gtk.Box box11;
		[GtkChild] Gtk.Button button1;
		[GtkChild] Gtk.Button button2;
		[GtkChild] Gtk.Button button3;
		[GtkChild] Gtk.Button button4;
		[GtkChild] Gtk.Label  label1;

		Graph.Smith smith;
		double alpha;
		int    M;

		private void on_clear() {
			M = 0;
			smith.clear();
		}

		private void on_add() {
			double re = Math.cos(alpha);
			double im = Math.sin(alpha);
			smith.add(re, im);
			alpha += Math.PI/180.0;
		}

		private void on_marker_inc() {
			var re = 0.0;
			var im = 0.0;
			char[] buf = new char[double.DTOSTR_BUF_SIZE];
			M++;
			if (!smith.marker(M)) M--;
			smith.getvalue(&re, &im);
			//label1.label = "Re = "+re.to_string()+" Im = "+im.to_string();
			label1.label = "Re = "+re.format(buf, "%.3f")+" Im = "+im.format(buf, "%.3f");
		}

		private void on_marker_dec() {
			var re = 0.0;
			var im = 0.0;
			char[] buf = new char[double.DTOSTR_BUF_SIZE];
			if (M > 0) M--;
			smith.marker(M);
			smith.getvalue(&re, &im);
			//label1.label = "Re = "+re.to_string()+" Im = "+im.to_string();
			label1.label = "Re = "+re.format(buf, "%.3f")+" Im = "+im.format(buf, "%.3f");
		}

		public Window (Gtk.Application app) {
			Object (application: app);

			alpha = 0.0;
			M     = 0;

			button1.clicked.connect (this.on_clear);
			button2.clicked.connect (this.on_add);
			button3.clicked.connect (this.on_marker_dec);
			button4.clicked.connect (this.on_marker_inc);

			smith = new Graph.Smith ();
			box11.pack_start (smith, true, true, 0);
			//smith.set_size_request (600, 600);

			this.show_all ();
		}
	}
}

