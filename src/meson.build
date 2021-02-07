vala_smith_sources = [
  'main.vala',
  'window.vala',
  'graph.vala',
]

vala_smith_deps = [
  dependency('glib-2.0', version: '>= 2.58'),
  dependency('gio-2.0', version: '>= 2.50'),
  dependency('gtk+-3.0', version: '>= 3.22'),
  math_dep,
]

gnome = import('gnome')

vala_smith_sources += gnome.compile_resources('vala_smith-resources',
  'vala_smith.gresource.xml',
  c_name: 'vala_smith'
)

executable('vala-smith', vala_smith_sources,
  vala_args: '--target-glib=2.50, -lm', dependencies: vala_smith_deps,
  install: true,
)

