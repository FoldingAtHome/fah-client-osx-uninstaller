# Setup
import os
import sys

if sys.platform != 'darwin':
    exit(0)

env = Environment(ENV = os.environ)
try:
    env.Tool('config', toolpath = [os.environ.get('CBANG_HOME'), './cbang'])
except Exception as e:
    raise Exception('CBANG_HOME not set?\n' + str(e))

env.CBLoadTools('packager')
conf = env.CBConfigure()

# Version
version = '0.1.5'
env.Replace(PACKAGE_VERSION = version)

conf.Finish()

# Flat Dist Components
distpkg_components = [
    {'name': 'Uninstaller',
        'home': '.',
        'pkg_id': 'org.foldingathome.uninstaller.pkg',
        'must_close_apps': [
            'org.foldingathome.fahviewer',
            'org.foldingathome.fahcontrol',
            'edu.stanford.folding.fahviewer',
            'edu.stanford.folding.fahcontrol',
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
    'distpkg_background' : 'fah-opacity-50.png',
    'distpkg_target' : '10.5',
    'distpkg_arch' : 'i386 ppc x86_64 arm64',
    'package_arch' : 'all',
    'distpkg_components' : distpkg_components,
    'distpkg_customize' : 'never', # only one component
    }

if 'package' in COMMAND_LINE_TARGETS:
    pkg = env.Packager(**parameters)
    AlwaysBuild(pkg)
    env.Alias('package', pkg)
    Clean(pkg, ['build', 'config.log'])
    NoClean(pkg, Glob(name + '*.pkg') , 'package.txt')

if 'distclean' in COMMAND_LINE_TARGETS:
    Clean('distclean', [
        '.sconsign.dblite', '.sconf_temp', 'config.log',
        'build', 'package.txt', 'package-description.txt',
        Glob(name + '*.pkg'),
        ])
