# flatdistpackager.py
# This should be integrated with packager.py

from SCons.Script import *

deps = ['packager', 'flatdistpkg']

def FlatDistPackager(env, name, **kwargs):
    # call old Packager if not building darwin flat dist
    distpkg_flat = kwargs.get('distpkg_flat', env.get('distpkg_flat', False))
    pkg_type = kwargs.get('pkg_type', env.get('pkg_type'))
    if env['PLATFORM'] != 'darwin' or pkg_type != 'dist' or not distpkg_flat:
        return env.Packager(name, **kwargs)

    # Setup env
    kwargs['package_name'] = name
    kwargs['package_name_lower'] = name.lower()
    env = env.Clone()
    env.Replace(**kwargs)

    # Compute package file name; eg name_version_arch.pkg.zip
    # flat dist packages should be pkg, not mpkg
    # installer doesn't seem to care, currently
    target = env.GetPackageName(name)

    return env.FlatDistPkg(target, [], **kwargs)

def configure(conf):
    env = conf.env
    AddMethod(Environment, FlatDistPackager, 'FlatDistPackager')
    return True
