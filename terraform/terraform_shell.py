import os
from subprocess import Popen, PIPE, STDOUT, run
import shutil
import boto3

def init(stack, bucket, region):
  "terraform init"
  print('terraform init')
  tf_init_cmd = "terraform init \
  -backend=true \
  -backend-config=\"bucket=%s\" \
  -backend-config=\"key=%s.tfstate\" \
  -backend-config=\"region=%s\"" % (bucket, stack, region)

  run(tf_init_cmd, shell=True)
  return

def plan(var_file, plan_file, stack, bucket, region, target):
  "terraform plan"
  init(stack, bucket, region)

  if target is None:
    tf_plan_cmd = "terraform plan -var-file='%s' -out='%s'" % (var_file, plan_file)
  else:
    tf_plan_cmd = "terraform plan -var-file='%s' -out='%s' -target=%s" % (var_file, plan_file, target)

  print('Running plan: %s' % tf_plan_cmd)

  run(tf_plan_cmd, shell=True)
  return

def apply(plan_file, state_file, backup_file, stack, bucket, region, target):
  "terraform apply"
  init(stack, bucket, region)
  
  if target is None:
    tf_apply_cmd = "terraform apply -backup=%s %s" % (backup_file, plan_file)
  else:
    tf_apply_cmd = "terraform apply -target=%s -backup=%s %s" % (backup_file, target, plan_file)

  print('Running apply: %s' % tf_apply_cmd)
  run(tf_apply_cmd, shell=True)

  shutil.rmtree('.terraform')

  s3_client = boto3.client('s3')
  s3_client.download_file(Bucket="%s" % (bucket), Key="%s.tfstate" % (stack), Filename="%s" % (state_file))
  return

def import_(var_file, address, id, stack, bucket, region):
  "terraform import"
  init(stack, bucket, region)
  tf_import_cmd = "terraform import -var-file=\"%s\" %s %s" % (var_file, address, id)
  print('Running import: %s' % tf_import_cmd)
  run(tf_import_cmd, shell=True)
  return

def destroy(var_file, stack, bucket, region):
  "terraform destroy"
  init(stack, bucket, region)
  tf_destroy_cmd = "terraform destroy -var-file=\"%s\"" % (var_file)
  print('Running destroy: %s' % tf_destroy_cmd)
  run(tf_destroy_cmd, shell=True)
  return

def graph(image_path, stack, bucket, region):
  "terraform graph"
  init(stack, bucket, region)
  tf_graph_cmd = "terraform graph -draw-cycles . > %s.dot" % (image_path)
  print('Running graph: %s' % tf_graph_cmd)
  run(tf_graph_cmd, shell=True)
  convert_dot_to_png = "cat %s.dot | dot -Goverlap=false -Tpng -o %s.png" % (image_path, image_path)
  print('Convert dot to png: %s' % convert_dot_to_png)
  run(tf_graph_cmd, shell=True)
  return

def refresh(var_file, backup_file, stack, bucket, region):
  "terraform refresh"
  init(stack, bucket, region)
  tf_refresh_cmd = "terraform refresh -var-file=\"%s\" -backup=%s" % (var_file, backup_file)
  print('Running refresh: %s' % tf_refresh_cmd)
  run(tf_refresh_cmd, shell=True)
  return

def taint(backup_file, state_file, address, stack, bucket, region):
  "terraform taint"
  init(stack, bucket, region)
  tf_taint_cmd = "terraform taint -backup=%s %s" % (backup_file, address)
  print('Running taint: %s' % tf_taint_cmd)
  run(tf_taint_cmd, shell=True)

  shutil.rmtree('.terraform')

  s3_client = boto3.client('s3')
  s3_client.download_file(Bucket="%s" % (bucket), Key="%s.tfstate" % (stack), Filename="%s" % (state_file))
  return

def state_mv(backup_file, state_file, src, dest, stack, bucket, region):
  "terraform state mv"
  init(stack, bucket, region)
  tf_state_mv_cmd = "terraform state mv -backup=%s %s %s" % (backup_file, src, dest)
  print('Running state: %s' % tf_state_mv_cmd)
  run(tf_state_mv_cmd, shell=True)

  shutil.rmtree('.terraform')

  s3_client = boto3.client('s3')
  s3_client.download_file(Bucket="%s" % (bucket), Key="%s.tfstate" % (stack), Filename="%s" % (state_file))
  return

def state_rm(backup_file, state_file, target, stack, bucket, region):
  "terraform state rm"
  init(stack, bucket, region)
  tf_state_rm_cmd = "terraform state rm -backup=%s %s" % (backup_file, target)
  print('Running state rm: %s' % tf_state_rm_cmd)
  run(tf_state_rm_cmd, shell=True)

  shutil.rmtree('.terraform')

  s3_client = boto3.client('s3')
  s3_client.download_file(Bucket="%s" % (bucket), Key="%s.tfstate" % (stack), Filename="%s" % (state_file))
  return