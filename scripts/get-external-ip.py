#!/usr/bin/env python
import sys
import os
import json
import urllib


def _get_stdin_params():
    if sys.stdin.isatty():
        return {}

    lines = [x.strip() for x in sys.stdin.readlines()]

    lines = filter(None, lines)
    if len(lines) == 0:
        return {}
    else:
        return json.loads(','.join(lines))


def main():
    params = _get_stdin_params()

    data = json.loads(urllib.urlopen("http://ip.jsontest.com/").read())
    # return {'result': {'ip': '{}'.format(data['ip'])}}
    # return {'ip': '{}'.format(data['ip'])}
    return data


if __name__ == '__main__':
    result = main()
    print(json.dumps(result))
