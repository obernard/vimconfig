#!/usr/bin/env python


from os import getenv, makedirs
import os.path
from subprocess import call


def main():
    vim_rc_file_path = os.path.join(getenv('HOME'), '.vimrc')
    vim_files_path = os.path.join(getenv('HOME'), '.vim')
    pathogen_URL = 'http://tpo.pe/pathogen.vim'
    pathogen_file_path = os.path.join(vim_files_path, 'autoload', 'pathogen.vim')

    if not os.path.exists(vim_rc_file_path):
        with open(vim_rc_file_path, mode='a') as f:
            f.write('source $HOME/vimconfig/.vimrc\n')

    for path in ['autoload', 'bundle']:
        absolute_path = os.path.join(vim_files_path, path)
        if not os.path.exists(absolute_path):
            makedirs(absolute_path)

    if not os.path.exists(pathogen_file_path):
        command = ['curl']
	# Managing the case the proxy is defined in /etc/environment file.
        if os.path.exists('/etc/environment'):
            with open('/etc/environment') as f:
                for line in f:
                    if 'http_proxy' in line:
                        proxy = line.split('=')[1].strip().strip('"')
                        command.append('-x')
                        command.append(proxy)
        command.append('-LSso')
        command.append(pathogen_file_path)
        command.append(pathogen_URL)
        call(command)

    bundle_folder = os.path.join(vim_files_path, 'bundle')
    with open('plugins.txt') as f:
        for line in f:
            plugin_remote_address = line.strip()
            plugin_name = plugin_remote_address.split('/')[-1].split('.')[0]
            destination_folder = os.path.join(bundle_folder, plugin_name)
            if not os.path.exists(destination_folder):
                call(['git', 'clone', plugin_remote_address, destination_folder])


if __name__ == '__main__':
	main()
