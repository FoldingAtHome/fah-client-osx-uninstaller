# Setup
import os
import sys
env = Environment(ENV = os.environ)
try:
    env.Tool('config', toolpath = [os.environ.get('CBANG_HOME')])
except Exception, e:
    raise Exception, 'CBANG_HOME not set?\n' + str(e)

env.CBLoadTools('packager')
conf = env.CBConfigure()

# Version
version = '0.1.1'
env.Replace(PACKAGE_VERSION = version)


# this should be in packager.configure
env.Append(PACKAGE_IGNORES = ['.DS_Store'])

# Flat Dist Components
distpkg_components = [
    {'name': 'Uninstaller',
        'home': '.',
        'pkg_id': 'foldingathome.org.uninstaller.pkg',
        'must_close_apps': [
            'foldingathome.org.fahviewer',
            'foldingathome.org.fahcontrol',
            ],
        'pkg_nopayload': True,
        'pkg_scripts': 'Scripts',
        },
    ]

# Package
# Note: a flat dist pkg does not need a pkg_id
name = 'fah-uninstaller'
parameters = {
    'name' : name,
    'version' : version,
    'maintainer' : 'Joseph Coffland <joseph@cauldrondevelopment.com>',
    'vendor' : 'Folding@home',
    'summary' : 'Folding@home Removal',
    'description' : 'Folding@home uninstaller package',
    'short_description' : 'Folding@home uninstaller package',
    'pkg_type' : 'dist',
    'distpkg_resources' : [['Resources', '.']],
    'distpkg_welcome' : 'Welcome.rtf',
    'distpkg_conclusion' : 'Conclusion.rtf',
    'distpkg_background' : 'fah-light.png',
    'distpkg_target' : '10.5',
    'distpkg_arch' : 'i386 ppc',
    'package_arch' : 'all',
    'distpkg_flat' : True,
    'distpkg_components' : distpkg_components,
    'distpkg_customize' : 'never', # only one component
    }
pkg = env.Packager(**parameters)

AlwaysBuild(pkg)
env.Alias('package', pkg)

# Clean
Clean(pkg, ['build', 'config.log'])
# ensure *.zip not cleaned unless distclean
NoClean(pkg, Glob('*.zip'))
if 'distclean' in COMMAND_LINE_TARGETS:
    Clean('distclean', [
        '.sconsign.dblite', '.sconf_temp', 'config.log',
        'build', 'package.txt', 'package-description.txt',
        Glob(name + '*.pkg'),
        Glob(name + '*.mpkg'),
        Glob(name + '*.zip'),
        ])
