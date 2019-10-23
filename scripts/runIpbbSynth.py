#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import toolbox as tb
import mp7patch

import argparse
import urllib
import shutil
import logging
from distutils.dir_util import copy_tree
import subprocess
import ConfigParser
import sys, os, re
import socket
from xmlmenu import XmlMenu
from run_simulation_questa import run_simulation_questa

EXIT_SUCCESS = 0
EXIT_FAILURE = 1

BoardAliases = {
    #'mp7_690es': 'r1',
    'mp7xe_690': 'xe',
}

DefaultBoardType = 'mp7xe_690'
"""Default board type to be used."""

DefaultFirmwareDir = os.path.expanduser("~/work_ipbb")
"""Default output directory for firmware builds."""

DefaultGitlabUrlIPB = 'https://github.com/ipbus/ipbus-firmware.git'
"""Default URL of github IPB repo."""

#DefaultGitlabUrlMP7 = 'https://:@gitlab.cern.ch:8443/hbergaue/mp7.git'
"""Default URL of gitlab MP7 repo."""

#DefaultGitlabUrlUgt = 'https://github.com/herbberg/ugt.git'
"""Default URL of github ugt GTL_v2_x_y repo."""

DefaultMenuUrl = 'https://raw.githubusercontent.com/herbberg/l1menus_gtl_v2_x_y/master'
    
DefaultVivadoVersion = '2018.3'
    
DefaultIpbbVersion = '0.2.8'

DefaultIpbbTag = 'master'

DefaultQuestasimVersion = '10.7c'

mp7fw_ugt_suffix = '_mp7_ugt'

vhdl_menu_files = ('l1menu.vhd','l1menu_pkg.vhd')

# For Questa simulation
QuestaSimPathVersion107c = '/opt/mentor/questasim'
QuestaSimPathVersion106a = '/opt/mentor/questa_core_prime_10.6a/questasim'
DefaultQuestaSimLibsName = 'questasimlibs' # generated im $HOME

def run_command(*args):
    command = ' '.join(args)
    logging.info(">$ %s", command)
    os.system(command)

def download_file_from_url(url, filename):
    """Download files from URL."""
    # Remove existing file.
    tb.remove(filename)
    # Download file
    logging.info("retrieving %s", url)
    urllib.urlretrieve(url, filename)
    tb.make_executable(filename)

    d = open(filename).read()
    d = d.replace(', default=os.getlogin()', '')
    with open(filename, 'wb') as fp:
        fp.write(d)

def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('menuname', type=tb.menuname_t, help="L1Menu name (eg. 'L1Menu_Collisions2018_v2_1_0-d1')")
    parser.add_argument('--menuurl', metavar='<path>', default=DefaultMenuUrl, help="L1Menu URL to retrieve files from (default is {})".format(DefaultMenuUrl))    
    parser.add_argument('--vivado', metavar='<version>', default=DefaultVivadoVersion, type=tb.vivado_t, help="Vivado version to run (default is '{}')".format(DefaultVivadoVersion))
    parser.add_argument('--ipbb', metavar='<version>', default=DefaultIpbbVersion, type=tb.ipbb_version_t, help="IPBus builder version [tag] (default is '{}')".format(DefaultIpbbVersion))
    parser.add_argument('--ipburl', metavar='<path>', default=DefaultGitlabUrlIPB, help="URL of IPB firmware repo (default is '{}')".format(DefaultGitlabUrlIPB))
    parser.add_argument('-i', '--ipb', metavar='<tag>', default=DefaultIpbbTag, help="IPBus firmware repo: tag or branch name (default is '{}')".format(DefaultIpbbTag))
    parser.add_argument('--mp7url', metavar='<path>', required=True, help="URL of MP7 firmware repo [required]")
    parser.add_argument('--mp7tag', metavar='<path>',required=True, help="MP7 firmware repo: tag name [required]")
    parser.add_argument('--ugturl', metavar='<path>', required=True, help="URL of ugt firmware repo [required]")
    parser.add_argument('--ugt', metavar='<path>',required=True, help='ugt firmware repo: tag or branch name [required]')
    parser.add_argument('--build', type=tb.build_str_t, required=True, metavar='<version>', help='menu build version (eg. 0x1001) [required]')
    parser.add_argument('--board', metavar='<type>', default=DefaultBoardType, choices=BoardAliases.keys(), help="set board type (default is '{}')".format(DefaultBoardType))
    parser.add_argument('-p', '--path', metavar='<path>', default=DefaultFirmwareDir, type=os.path.abspath, help="fw build path (default is '{}')".format(DefaultFirmwareDir))
    parser.add_argument('--sim', action='store_true', help='running simulation with Questa simulator (before synthesis)')
    parser.add_argument('--simmp7path', metavar='<tag>', help="local MP7 firmware repo [required if sim is set]")
    parser.add_argument('--questasim', type=tb.questasim_t, default=DefaultQuestasimVersion, help = "Questasim version (default is  '{}')".format(DefaultQuestasimVersion))
    parser.add_argument('--questasimlibs', metavar='<path>', default=DefaultQuestaSimLibsName, help = "Questasim Vivado libraries directory name (default: '{}') [useful if sim is set]".format(DefaultQuestaSimLibsName))
    parser.add_argument('--output', metavar = '<path>', help = 'directory for sim results [useful if sim is set]', type = os.path.abspath)
    return parser.parse_args()

def main():
    """Main routine."""

    # Parse command line arguments.
    args = parse_args()

    # Setup console logging
    logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.INFO)
    
    # Check for VIVADO_BASE_DIR
    vivado_base_dir = os.getenv('VIVADO_BASE_DIR')
    if not vivado_base_dir:
        raise RuntimeError("Environment variable 'VIVADO_BASE_DIR' not set. Set with: 'export VIVADO_BASE_DIR=...'")
    
    # Setup console logging
    logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.DEBUG)
    
    # Board type taken from mp7url repo name
    board_type_repo_name = os.path.basename(args.mp7url)
    if board_type_repo_name.find(".") > 0:
        board_type = board_type_repo_name.split('.')    # Remove ".git" from repo name
    else:
        board_type = board_type_repo_name
        
    # Project type taken from ugturl repo name
    project_type_repo_name = os.path.basename(args.ugturl)
    if project_type_repo_name.find(".") > 0:
        project_type = project_type_repo_name.split('.')    # Remove ".git" from repo name
    else:
        project_type = project_type_repo_name
    
    # Create MP7 tag name for ugt    
    mp7fw_ugt = args.mp7tag + mp7fw_ugt_suffix
    
    ipbb_dir = os.path.join(args.path, project_type, args.mp7tag, args.menuname, args.build)

    if os.path.isdir(ipbb_dir):
        raise RuntimeError("build area alredy exists: {}".format(ipbb_dir))
    
    # Runnig simulation with Questa simulator, if args.sim is set    
    if args.sim:
        logging.info("===========================================================================")
        logging.info("running simulation with Questa ...")
        run_simulation_questa(args.simmp7path, args.menuname, args.vivado, args.questasim, args.questasimlibs, args.output, False, False, False)
    else:
        logging.info("===========================================================================")
        logging.info("no simulation required ...")
                
    ipbb_version = args.ipbb
    ipbb_version_path = os.path.join(os.getenv("HOME"),"ipbb-{}".format(ipbb_version))
    
    if not os.path.isdir(ipbb_version_path):
        logging.info("execute 'curl' command ...")
        cmd_curl = "curl -L https://github.com/ipbus/ipbb/archive/v{ipbb_version}.tar.gz | tar xvz".format(**locals())
        command = 'bash -c "cd; {cmd_curl}"'.format(**locals())
        run_command(command)
    
    # IPBB commands: creating IPBB area
    cmd_source_ipbb = "source ipbb-{ipbb_version}/env.sh".format(**locals())
    cmd_ipbb_init = "ipbb init {ipbb_dir}".format(**locals())
    cmd_ipbb_add_ipb = "ipbb add git {args.ipburl} -b {args.ipb}".format(**locals())
    cmd_ipbb_add_mp7 = "ipbb add git {args.mp7url} -b {mp7fw_ugt}".format(**locals())
    cmd_ipbb_add_ugt = "ipbb add git {args.ugturl} -b {args.ugt}".format(**locals())

    logging.info("===========================================================================")
    logging.info("creating IPBB area ...")
    command = 'bash -c "cd; {cmd_source_ipbb}; {cmd_ipbb_init}; cd {ipbb_dir}; {cmd_ipbb_add_ipb} && {cmd_ipbb_add_mp7} && {cmd_ipbb_add_ugt}"'.format(**locals())
    run_command(command)

    logging.info("===========================================================================")
    logging.info("download XML file from L1Menu repository ...")
    xml_name = "{}{}".format(args.menuname, '.xml')
    url_menu = "{}/{}".format(args.menuurl, args.menuname)
    #print "url_menu",url_menu
    filename = os.path.join(ipbb_dir, 'src', xml_name)
    url = "{url_menu}/xml/{xml_name}".format(**locals())    
    download_file_from_url(url, filename)
    
    menu = XmlMenu(filename)

    # Fetch menu name from path.
    menu_name = menu.name

    if not menu_name.startswith('L1Menu_'):
        raise RuntimeError("Invalid menu name: {}".format(menu_name))

    # Fetch number of menu modules.
    modules = menu.n_modules

    if not modules:
        raise RuntimeError("Menu contains no modules")

    ipbb_src_fw_dir = os.path.abspath(os.path.join(ipbb_dir, 'src', project_type, 'firmware'))
    
    for module_id in range(modules):
        module_name = 'module_{}'.format(module_id)
        ipbb_module_dir = os.path.join(ipbb_dir, module_name)
        
        ipbb_dest_fw_dir = os.path.abspath(os.path.join(ipbb_dir, 'src', module_name))
        os.makedirs(ipbb_dest_fw_dir)

        #Download generated VHDL files from repository
        logging.info("===========================================================================")
        logging.info(" *** module %s ***", module_id)
        logging.info("===========================================================================")
        logging.info("download generated VHDL menu files from L1Menu repository for module %s ...", module_id)
        
        for i in range(len(vhdl_menu_files)):
            vhdl_menu_file = vhdl_menu_files[i]
            filename = os.path.join(ipbb_dest_fw_dir, vhdl_menu_file)
            url = "{url_menu}/vhdl/{module_name}/src/{vhdl_menu_file}".format(**locals())
            download_file_from_url(url, filename)

        logging.info("patch the target package with current UNIX timestamp/username/hostname ...")
        top_pkg_tpl = os.path.join(ipbb_src_fw_dir, 'hdl', 'packages', 'top_decl_tpl.vhd')
        top_pkg = os.path.join(ipbb_src_fw_dir, 'hdl', 'packages', 'top_decl.vhd')
        subprocess.check_call(['python', os.path.join(ipbb_src_fw_dir, '..', 'scripts', 'pkgpatch.py'), '--build', args.build, top_pkg_tpl, top_pkg])
        
        #Vivado settings
        settings64 = os.path.join(vivado_base_dir, args.vivado, 'settings64.sh')
        if not os.path.isfile(settings64):
            raise RuntimeError(
                "no such Xilinx Vivado settings file '{settings64}'\n" \
                "  check if Xilinx Vivado {args.vivado} is installed on this machine.".format(**locals())
            )

        logging.info("===========================================================================")
        logging.info("creating IPBB project for module %s ...", module_id)
        cmd_ipbb_proj_create = "ipbb proj create vivado module_{module_id} mp7:../{project_type}".format(**locals())
        
        command = 'bash -c "cd; {cmd_source_ipbb}; cd {ipbb_dir}; {cmd_ipbb_proj_create}"'.format(**locals())
        run_command(command)
        
        logging.info("===========================================================================")
        logging.info("running IPBB project, synthesis and implementation, creating bitfile for module %s ...", module_id)
        
        #IPBB commands: running IPBB project, synthesis and implementation, creating bitfile
        cmd_ipbb_project = "ipbb vivado project"
        cmd_ipbb_synth = "ipbb vivado synth"
        cmd_ipbb_impl = "ipbb vivado impl"
        cmd_ipbb_bitfile = "ipbb vivado package"
        
        ##Set variable "module_id" for tcl script (l1menu_files.tcl in top.dep)
        command = 'bash -c "cd; {cmd_source_ipbb}; source {settings64}; cd {ipbb_dir}/proj/module_{module_id}; module_id={module_id} {cmd_ipbb_project} && {cmd_ipbb_synth} && {cmd_ipbb_impl} && {cmd_ipbb_bitfile}"'.format(**locals())

        session = "build_{project_type}_{args.build}_{module_id}".format(**locals())
        logging.info("starting screen session '%s' for module %s ...", session, module_id)
        run_command('screen', '-dmS', session, command)

    # list running screen sessions
    logging.info("===========================================================================")
    run_command('screen', '-ls')

    os.chdir(ipbb_dir)

    # Creating configuration file.
    config = ConfigParser.RawConfigParser()
    config.add_section('environment')
    config.set('environment', 'timestamp', tb.timestamp())
    config.set('environment', 'hostname', tb.hostname())
    config.set('environment', 'username', tb.username())

    config.add_section('menu')
    # Remove "0x" from args.build
    build_raw = args.build.split("x", 1)
    config.set('menu', 'build', build_raw[1])

    config.set('menu', 'name', menu_name)
    config.set('menu', 'location', url_menu)
    config.set('menu', 'modules', modules)

    config.add_section('ipbb')
    config.set('ipbb', 'version', ipbb_version)
    
    config.add_section('firmware')
    config.set('firmware', 'ipburl', args.ipburl)
    config.set('firmware', 'ipbtag', args.ipb)
    config.set('firmware', 'mp7url', args.mp7url)
    config.set('firmware', 'mp7tag', args.mp7tag)
    config.set('firmware', 'mp7fw_ugt', mp7fw_ugt)
    config.set('firmware', 'ugturl', args.ugturl)
    config.set('firmware', 'ugttag', args.ugt)
    config.set('firmware', 'type', project_type)
    config.set('firmware', 'buildarea', ipbb_dir)

    config.add_section('device')
    config.set('device', 'type', args.board)
    config.set('device', 'name', board_type[0])
    config.set('device', 'alias', BoardAliases[args.board])

    # Writing configuration file
    with open('build_{}.cfg'.format(args.build), 'wb') as fp:
        config.write(fp)

    logging.info("created configuration file: %s/build_%s.cfg.", ipbb_dir, args.build)
    logging.info("done.")

if __name__ == '__main__':
    try:
        main()
    except RuntimeError, message:
        logging.error(message)
        sys.exit(EXIT_FAILURE)
    sys.exit(EXIT_SUCCESS)
