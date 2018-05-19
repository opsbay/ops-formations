#!/usr/local/bin/python3

import sys
import os
import getopt
import configparser
import datetime
from subprocess import Popen, PIPE, STDOUT, run
import shutil

instruction = 'Usage: build-ami.py -t packer/abc.json'
config = configparser.ConfigParser()


def main(argv):
    target = ''
    try:
        opts, args = getopt.getopt(argv, "h:t:", [
                                   "target=",
                                   ])
    except getopt.GetoptError:
        print(instruction)
        sys.exit(2)

    if len(opts) <= 0:
        print(instruction)
        sys.exit()

    for opt, arg in opts:
        if opt == '-h':
            print(instruction)
            sys.exit()
        elif opt in ("-t", "--target"):
            target = arg

    cwd = os.getcwd()

    config.read("./env/env.ini")
    print('default:', config['default'])
    print('AWS_PROFILE:', config['default']['AWS_PROFILE'])
    print('AWS_REGION:', config['default']['AWS_REGION'])

    now = datetime.datetime.now()

    os.environ['AWS_PROFILE'] = config['default']['AWS_PROFILE']
    os.environ['AWS_REGION'] = config['default']['AWS_REGION']

    print('Running packer.')

    packer_cmd = "packer build \
    -var-file=%s/env/packer_vars.json %s \
    " % (cwd, target)

    run(packer_cmd, shell=True)


if __name__ == "__main__":
    main(sys.argv[1:])
