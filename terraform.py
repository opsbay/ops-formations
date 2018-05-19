#!/usr/local/bin/python3

import sys
import os
import re
import configparser
import datetime
from subprocess import Popen, PIPE, STDOUT, run
import shutil

from terraform import terraform_shell as terraform

allowed_commands = ["init", "plan", "apply", "destroy", "import", "graph", "refresh", "taint", "state_mv", "state_rm"]

instruction = 'Usage: terraform.py :command(%s) :stack [...:others]' % ('|'.join(allowed_commands))
config = configparser.ConfigParser()

def main(argv):
  if len(argv) < 2:
    print(instruction)
    sys.exit()

  command = argv[0]
  if command not in allowed_commands:
    print(instruction)
    sys.exit()

  stack = argv[1]
  if not stack:
    print(instruction)
    sys.exit()
  
  rest_args = argv[1:]

  cwd = os.getcwd()

  print('Command is', command)
  print('Stack is', stack)

  config.read("./env/env.ini")

  print('AWS_PROFILE:', config['default']['AWS_PROFILE'])
  print('AWS_REGION:', config['default']['AWS_REGION'])
  print('STATE_BUCKET:', config['default']['STATE_BUCKET'])

  now = datetime.datetime.now()

  os.environ['AWS_PROFILE'] = config['default']['AWS_PROFILE']
  os.environ['AWS_REGION'] = config['default']['AWS_REGION']
  os.environ['STATE_BUCKET'] = config['default']['STATE_BUCKET']
  os.environ['TF_LOG'] = 'DEBUG'
  os.environ['TF_LOG_PATH'] = "%s/logs/.log" % (cwd)
  os.environ['TF_VAR_build_datetime'] = now.strftime("%Y%m%d%H%M%S")
  os.environ['TF_VAR_state_bucket'] = config['default']['STATE_BUCKET']
  os.environ['TF_VAR_root_path'] = cwd

  statePath = "%s/state" % (cwd)
  if not os.path.exists(statePath):
    os.mkdir(statePath)

  if not stack == 'default':
    os.chdir('./terraform/%s' % (stack))
  else:
    os.chdir('./terraform')

  if os.path.exists('.terraform'):
    print('remove local state cache')
    shutil.rmtree('.terraform')

  bucket = config['default']['STATE_BUCKET']
  region = config['default']['AWS_REGION']
  plan_file = "%s/state/%s.plan" % (cwd, stack)
  var_file = "%s/env/main.tfvars" % (cwd)
  backup_file = "%s/state/%s.tfstate.backup" % (cwd, stack)
  state_file = "%s/state/%s.tfstate" % (cwd, stack)

  if command == 'plan':
    if len(argv) > 2:
      target = argv[2]
    else:
      target = None
    terraform.plan(var_file, plan_file, stack, bucket, region, target)
  elif command == 'apply':
    if len(argv) > 2:
      target = argv[2]
    else:
      target = None
    terraform.apply(plan_file, state_file, backup_file, stack, bucket, region, target)
  elif command == 'import':
    address = argv[2]
    id = argv[3]
    terraform.import_(var_file, address, id, stack, bucket, region)
  elif command == 'destroy':
    terraform.destroy(var_file, stack, bucket, region)
  elif command == 'graph':
    image_path = "%s/state/%s" % (cwd, stack)
    terraform.graph(image_path, stack, bucket, region)
  elif command == 'refresh':
    terraform.refresh(var_file, backup_file, stack, bucket, region)
  elif command == 'init':
    terraform.init(stack, bucket, region)
  elif command == 'taint':
    address = argv[2]
    terraform.taint(backup_file, state_file, address, stack, bucket, region)
  elif command == 'state_mv':
    src = argv[2]
    dest = argv[3]
    terraform.state_mv(backup_file, state_file, src, dest, stack, bucket, region)
  elif command == 'state_rm':
    target = argv[2]
    terraform.state_rm(backup_file, state_file, target, stack, bucket, region)
        
if __name__ == "__main__":
    main(sys.argv[1:])
