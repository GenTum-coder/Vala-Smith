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
		//[GtkChild] Gtk.Box box1;
		[GtkChild] Gtk.Box box11;
		[GtkChild] Gtk.Button button1;

		Graph.Smith smith;
		//Gtk.Label label1;

		private void on_click() {
			//smith.redraw_canvas();
			smith.update();
			//label1.label = "Hello World!";
		}

		public Window (Gtk.Application app) {
			Object (application: app);

			button1.clicked.connect (this.on_click);

			smith = new Graph.Smith ();
			box11.pack_start (smith, true, true, 0);
			//smith.set_size_request (600, 600);
			//label1 = new Gtk.Label ("label1");
			//box1.pack_start (label1, false, false, 0);

			this.show_all ();
		}
	}
}

